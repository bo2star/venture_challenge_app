require 'test_helper'

class ShopifyWebhooksTest < ActionDispatch::IntegrationTest

  test 'create' do
    post '/shopify_webhooks', {}, { 'HTTP_X_SHOPIFY_SHOP_DOMAIN' => shops(:mariners_inn).shopify_uid }
    assert_response :success
  end

end