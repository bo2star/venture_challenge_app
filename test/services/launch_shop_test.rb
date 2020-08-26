require 'test_helper'

class LaunchShopTest < ActiveSupport::TestCase

  test 'launching a shop' do
    req = shop_requests(:one)
    shop = LaunchShop.call(req, '333')

    assert_equal 'My Shop', shop.name
    assert_equal 'my-shop.myshopify.com', shop.url
    assert_equal '111', shop.shopify_uid

    assert_equal teams(:bobs_team), shop.team

    assert shop.team.task_with_code('launch').complete?

    assert_equal '333', Charge.last.uid
    assert_equal shop, Charge.last.shop

    # It should mark the shop request as complete.
    assert_not req.is_pending
  end

end
