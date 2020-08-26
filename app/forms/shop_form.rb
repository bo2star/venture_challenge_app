class ShopForm
  include ActiveModel::Model

  attr_accessor :url, :coupon_code, :user_count

  validate :verify_url_format
  validate :validate_coupon_code

  def initialize(params = {})
    self.url = params[:url]
    self.coupon_code = params[:coupon_code]
    self.user_count = params[:user_count]
  end

  def shop_domain
    strip_admin_path( strip_url_protocol(url) )
  end

  protected

    def verify_url_format
      if url.blank?
        errors.add :url, 'is required.'
        return
      end

      if url !~ /.+\.myshopify.com.*/
        errors.add :url, "should look like 'example.myshopify.com'."
        return
      end

      if normalize_url(url) !~ URI::ABS_URI
        errors.add :url, 'is not a valid URL.'
      end
    end

    def validate_coupon_code
      if coupon_code.present? && !Coupons.find(coupon_code, user_count)
        errors.add :coupon_code, 'is not valid.'
      end
    end

  private

    def normalize_url(url)
      'http://' + strip_url_protocol(url)
    end

    def strip_url_protocol(url)
      url.sub(%r(http[s]?://), '')
    end

    def strip_admin_path(url)
      url.sub(%r(/admin$), '')
    end

end
