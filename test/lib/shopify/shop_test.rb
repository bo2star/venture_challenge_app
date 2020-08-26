require_relative '../../test_helper'

class Shopify::ShopTest < ActiveSupport::TestCase

  SHOPIFY_UID = 'marinersinnonline.myshopify.com'
  SHOPIFY_TOKEN = 'bdef681ecc9170eae84f008db27d6681'

  test 'fetch_customers' do
    customers = VCR.use_cassette('fetch_customers') do
      shop.fetch_customers
    end

    assert_equal 9, customers.size
    assert customers.first.kind_of?(Shopify::Customer)
    assert_equal 'sallyn313@gmail.com', customers.first.email
  end

  test 'fetch_customers with pagination' do
    customers = VCR.use_cassette('fetch_customers_with_pagination') do
      shop.fetch_customers(limit: 5, page: 2)
    end

    assert_equal 4, customers.size
  end

  test 'fetch_orders' do
    orders = VCR.use_cassette('fetch_orders') do
      shop.fetch_all_orders
    end

    assert_equal 15, orders.size
    assert orders.first.kind_of?(Shopify::Order)
    assert_equal '304471635', orders.first.customer_uid
  end

  test 'fetch_webhooks' do
    webhooks = VCR.use_cassette('fetch_webhooks') do
      shop.fetch_webhooks
    end

    assert_equal 2, webhooks.size
    assert webhooks.first.kind_of?(Shopify::Webhook)
    assert_equal 'orders/create', webhooks.first.topic
  end

  test 'fetch_application_charge' do
    shop = Shopify::Shop.new('shoes-for-humanity.myshopify.com', '2c0887bb02f475d7887c6d613ff1b337')

    app_charge = VCR.use_cassette('fetch_application_charge') do
      shop.fetch_application_charge('693137')
    end

    assert app_charge.kind_of?(Shopify::ApplicationCharge)
    assert_equal '693137', app_charge.id
  end

  def shop
    @shop ||= Shopify::Shop.new(SHOPIFY_UID, SHOPIFY_TOKEN)
  end

end
