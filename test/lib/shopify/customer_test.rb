require_relative '../../test_helper'

class Shopify::CustomerTest < ActiveSupport::TestCase

  test "creating from shopify hash" do
    customer = Shopify::Customer.new( load_json('shopify_customer') )

    assert_equal '207119551', customer.uid
    assert_equal 'bob.norman@hostmail.com', customer.email
    assert_equal Time.zone.parse('2014-09-15T15:16:38-04:00'), customer.created_at
  end
end
