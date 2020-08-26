require_relative '../../test_helper'

class Shopify::OrderTest < ActiveSupport::TestCase

  test 'creating from shopify hash' do
    order = Shopify::Order.new( load_json('shopify_order') )

    assert_equal '450789469', order.uid
    assert_equal Time.zone.parse('2008-01-10T11:00:00-05:00'), order.created_at
    assert_equal '207119551', order.customer_uid
    assert_equal 'authorized', order.financial_status
    assert_equal 'http://www.otherexample.com', order.referring_site
    assert_equal 398.00, order.subtotal_price
    assert_equal 11.94, order.total_tax
    assert_equal 0.00, order.total_discounts
    assert_equal 409.94, order.total_price

    line_items = [{
      "uid"=>466157049, 
      "price"=>199.00, 
      "product_uid"=>632910392, 
      "quantity"=>1, 
      "sku"=>"IPOD2008GREEN", 
      "title"=>"IPod Nano - 8gb", 
      "name"=>"IPod Nano - 8gb - green"
    }, {
      "uid"=>518995019, 
      "price"=>199.00, 
      "product_uid"=>632910392, 
      "quantity"=>1, 
      "sku"=>"IPOD2008RED", 
      "title"=>"IPod Nano - 8gb", 
      "name"=>"IPod Nano - 8gb - red"}, 
    {
      "uid"=>703073504, 
      "price"=>199.00, 
      "product_uid"=>632910392, 
      "quantity"=>1, 
      "sku"=>"IPOD2008BLACK", 
      "title"=>"IPod Nano - 8gb", 
      "name"=>"IPod Nano - 8gb - black"
    }]
    assert_equal line_items, order.line_items
  end

  test 'cash order has nil customer_uid' do
    hash = load_json('shopify_cash_order')

    assert_equal nil, hash['customer']

    order = Shopify::Order.new(hash)

    assert_equal nil, order.customer_uid
  end

end
