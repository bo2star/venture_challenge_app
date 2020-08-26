require_relative '../test_helper'

class ShopFormTest < ActiveSupport::TestCase

  test 'is is valid with valid shopify urls' do
    %w(
      my-store.myshopify.com
      http://my-store.myshopify.com
      https://my-store.myshopify.com
      http://my-store.myshopify.com/admin
    ).each do |url|
      assert ShopForm.new(url: url).valid?, "should be valid with url #{url}"
    end
  end

  test 'is is invalid with invalid shopify urls' do
    [
      'http://my-store.other.com',
      'myshopify.com',
      'my-store.myshoopify.com',
      'http://an invalid url.myshopify.com'
    ].each do |url|
      refute ShopForm.new(url: url).valid?, "should not be valid with url #{url}"
    end
  end

  test 'it parses out the shop domain' do
    [
      ['my-store.myshopify.com', 'my-store.myshopify.com'],
      ['my-store.myshopify.com', 'my-store.myshopify.com/admin'],
      ['my-store.myshopify.com', 'https://my-store.myshopify.com/admin']
    ].each do |(domain, url)|
      assert_equal domain, ShopForm.new(url: url).shop_domain
    end
  end

end
