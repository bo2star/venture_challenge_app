require 'test_helper'

class ShopTest < ActiveSupport::TestCase

  def setup
    @shop = shops(:bobs_pants)
  end

  test 'referrals' do
    assert_equal 13, @shop.referrals.count
  end

  test 'last_acquired_customer' do
    assert_equal 'sallyn313@gmail.com', @shop.last_acquired_customer.email
  end

  test 'last_placed_order' do
    assert_equal '1266172947', @shop.last_placed_order.uid
  end

end
