# PostApplicationCharge
#
# Post an application charge to shopify, given a shop's credentials. The price
# is $25 per user (team member).
#
# Shopify will redirect the user to the given return url after the charge has been accepted or declined.
# See ShopsController for more details.
#
class PostApplicationCharge
  extend Service

  def initialize(shopify_uid, shopify_token, user_count:, coupon_code:)
    @uid = shopify_uid
    @token = shopify_token
    @user_count = user_count
    @coupon_code = coupon_code
  end

  def call
    api = Shopify::Shop.new(@uid, @token)

    api.post_application_charge( price: price ,
                                 name: 'Online Venture Challenge',
                                 return_url: return_url,
                                 test: test? )
  end

  private

    def test?
      !Rails.env.production? || ENV['FREE_TRIAL'].to_s.downcase == 'true'
    end

    def return_url
      if Rails.env.production?
        'http://app.onlineventurechallenge.com/shop_confirmation_callback'
      else
        'http://app.onlineventurechallenge.dev/3112/shop_confirmation_callback'
      end
    end

    def price
      discount = Coupons.redeem(@coupon_code, amount: @user_count * 25.0)[:discount]
      price = [25.0 * @user_count, 100].max
      total = price - discount

      # Shopify requires a charge > 0.0 to be posted
      # TODO: Make it so that we don't post an application charge at all when the price is 0.
      total > 0 ? total : 1.0
    end

end