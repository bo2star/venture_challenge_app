class Student::ShopsController < StudentController

  before_action :require_student
  before_action :require_team
  before_action :require_no_shop

  # 1 - Show a form to enter their shop URL.
  #
  def new
    @form = ShopForm.new
  end

  # 2 - Receive submitted shop URL.
  # Expects "shop_form[url]" to contain a valid shopify shop URL.
  #
  # If URL valid, redirect to authenticate with Shopify.
  # Else show form again.
  #
  def create
    @form = ShopForm.new(params[:shop_form].merge(user_count: current_team.students.size))

    if @form.valid?
      current_team.update!(coupon_code: @form.coupon_code)
      redirect_to "/auth/shopify?shop=#{@form.shop_domain}"
    else
      render :new
    end
  end

  # 3a - Successfully authenticated with Shopify.
  # Expects "omniauth.auth" header to contain omniauth hash.
  #
  # Create a ShopRequest to store shop details for later.
  # Post an application charge to Shopify, with a return URL pointing to step 4.
  #
  def auth_success
    auth = Shopify::Authentication.new(env['omniauth.auth'])

    if !auth.valid?
      redirect_to new_shop_path, alert: "Sorry, we're having trouble communicating with Shopify. Please try again later."
      return
    end


    if Shop.unique_uid?(auth.uid)
      app_charge = PostApplicationCharge.call(auth.uid, auth.token, user_count: current_team.students.size, coupon_code: current_team.coupon_code)

      ShopRequest.create!( team: current_team,
                           name: auth.name,
                           url: auth.url,
                           shopify_uid: auth.uid,
                           shopify_token: auth.token,
                           confirmation_url: app_charge.confirmation_url )

      redirect_to app_charge.confirmation_url

    else
      # This shop is already in use, or has a pending request. Stop the user early so that they can't
      # accept the charge and think that they've paid before getting a error saying this shop is in use.
      redirect_to new_shop_path, alert: 'This shop is already in use by another team. Please create a new shop.'
    end
  end

  # 3b - Failed to authenticate with Shopify (invalid shop URL?).
  # Show form again with an error message.
  #
  def auth_failure
    redirect_to new_shop_path, alert: 'There is no Shopify shop matching this URL, please try again.'
  end

  # 4 - Receive Shopify confirmation response
  # Expects "charge_id" param to be the id of a valid shopify application charge.
  #
  # Fetch the given application charge from Shopify.
  # If accepted:
  #   - Complete the latest pending shop request.
  #   - Create a charge (to be activated later).
  # If declined, show the form again with an error message.
  #
  def confirmation_callback
    req = current_team.latest_pending_shop_request

    app_charge = FetchApplicationCharge.call(req.shopify_uid, req.shopify_token, params[:charge_id])

    if app_charge.accepted?
      shop = LaunchShop.call(req, app_charge.id)

      redirect_to team_path, notice: "Your shop '#{shop.name}' has been launched. Now go make some money!"

    else
      # Make the shop request as completed, because shopify requires that we create a new application charge
      # when one is declined. Therefore, they'll need to create a new shop request.
      req.complete
      redirect_to new_shop_path, alert: 'The application charge must be accepted to launch your shop'

    end

  rescue LaunchShop::ShopNotUniqueError => e
    redirect_to new_shop_path, alert: "This shop is already in use."

  rescue StandardError => e
    # Being paranoid here because this is where we *seem to* accept money, so we never want to appear to *break*
    # at this point. (We don't actually accept money until the charge is created, though). In the unlikely case that there's a network error communicating with shopify,
    # or an unknown error, we show the user a useful message instead of showing an error page.
    ReportError.call(e.message)
    redirect_to new_shop_path, alert: "Sorry, something went wrong setting up the application. Please contact support."
  end

  protected

    def require_no_shop
      redirect_to(team_path, alert: 'You already have a shop.') if current_team.shop
    end

end