require_relative '../test_helper'

class ShopSynchronizerTest < ActiveSupport::TestCase

  def setup
    @shop = shops(:mariners_inn)
    @sync = ShopSynchronizer.new(@shop)
  end

  test 'synchronize_customers' do
    assert_equal 0, @shop.customers.size

    VCR.use_cassette('fetch_shop_customers') do
      @sync.synchronize_customers
    end

    assert_equal 9, @shop.customers.size

    # Does nothing if called a second time

    VCR.use_cassette('fetch_shop_customers_again') do
      @sync.synchronize_customers
    end

    assert_equal 9, @shop.customers.size
  end

  test 'synchronize_orders' do
    assert_equal 0, @shop.orders.size

    VCR.use_cassette('fetch_shop_orders') do
      @sync.synchronize_orders
    end

    assert_equal 15, @shop.orders.size

    # Creates referrals when there is one.
    assert_equal 15, @shop.referrals.size

    assert_equal 17, @shop.line_items.size

    # Does nothing if called a second time

    VCR.use_cassette('fetch_shop_orders_again') do
      @sync.synchronize_orders
    end

    assert_equal 15, @shop.orders.size
  end

  test 'synchronize_products' do
    assert_equal 0, @shop.products.size

    # We need the order data before synchronizing products.
    VCR.use_cassette('fetch_shop_orders') do
      @sync.synchronize_orders
    end

    @sync.synchronize_products

    assert_equal 7, @shop.products.size
    assert_equal 'Caramel Arrow Sweater', @shop.products.first.name
    assert_equal 45.0, @shop.products.first.total_revenue
    assert_equal 1, @shop.products.first.quantity

    # It should be idempotent
    @sync.synchronize_products
    assert_equal 7, @shop.products.size
  end

  test 'synchronize' do

    # Don't try to create webhooks.
    WebMock::API.stub_request(:post, /.*/).to_return(status: 201)

    VCR.use_cassette('fetch_shop_all') do
      @sync.synchronize
    end

  end

  test 'processes cash orders' do
    shp_order = Shopify::Order.new( load_json('shopify_cash_order') )

    @sync.process_order(shp_order)

    assert_equal 1, @shop.orders.count

    # There is no customer on a cash order.
    assert_equal nil, @shop.orders.last.customer_uid
  end

end