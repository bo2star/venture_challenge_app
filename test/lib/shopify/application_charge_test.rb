require_relative '../../test_helper'

class Shopify::ApplicationChargeTest < ActiveSupport::TestCase

  test "creating from shopify hash" do
    charge = Shopify::ApplicationCharge.new( load_json('shopify_application_charge') )

    assert_equal '1012637314', charge.id
    assert_equal 'pending', charge.status
    assert_equal 'https://apple.myshopify.com/admin/charges/1012637314/confirm_application_charge?signature=BAhpBIKeWzw%3D--892bb512fcaf56f212d64973376b51949f5214ac', charge.confirmation_url
    assert_equal 'http://super-duper.shopifyapps.com', charge.return_url
    assert_equal 'Super Duper Expensive action', charge.name
  end
end
