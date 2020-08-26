# LaunchShop
#
# Given a Shop Request, which contains the attributes for the shop, and a uid for an accepted shopify application charge:
# - Create a shop for the team.
# - Mark the team's "launch" task as complete.
# - Synchronize the team's stats in case they already have orders.
# - Create a Charge to be activated later.
#
class LaunchShop
  extend Service

  class ShopNotUniqueError < StandardError; end

  def initialize(shop_request, charge_uid)
    @shop_request = shop_request
    @charge_uid = charge_uid
  end

  def call
    ActiveRecord::Base.transaction do
      shop = create_shop
      create_charge(shop)
      complete_shop_request

      shop
    end

  rescue ActiveRecord::RecordNotUnique => e
    raise ShopNotUniqueError
  end

  private

    def create_shop
      team = @shop_request.team

      shop = Shop.create!( team: team,
                           name: @shop_request.name,
                           url: @shop_request.url,
                           shopify_uid: @shop_request.shopify_uid,
                           shopify_token: @shop_request.shopify_token )

      team.task_with_code(:launch).complete

      # Synchronize the shop data now instead of waiting for the next scheduled check.
      SynchronizeTeamJob.new.async.perform(team.id)

      shop
    end

    def create_charge(shop)
      Charge.create!(shop: shop, uid: @charge_uid)
    end

    def complete_shop_request
      @shop_request.complete
    end

end