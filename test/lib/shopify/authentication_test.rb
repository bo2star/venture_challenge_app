require_relative '../../test_helper'

class Shopify::AuthenticationTest < ActiveSupport::TestCase

  HASH = {
    provider: "shopify",
    uid: "shoes-for-humanity.myshopify.com",
    info: { name: nil },
    credentials: {
      token: "2c0887bb02f475d7887c6d613ff1b337",
      expires: false
    },
    extra: { }
  }.with_indifferent_access

  test "creating from omniauth hash" do
    auth = Shopify::Authentication.new(HASH)

    assert_equal "2c0887bb02f475d7887c6d613ff1b337", auth.token
    assert_equal "shoes-for-humanity.myshopify.com", auth.uid
    assert_equal "shoes-for-humanity.myshopify.com", auth.url
    assert_equal "Shoes For Humanity", auth.name
  end

  test 'valid with valid omniauth hash' do
    assert Shopify::Authentication.new(HASH).valid?
  end

  test 'invalid with invalid omniauth hash' do
    hash = { 'provider' => 'shopify' }
    refute Shopify::Authentication.new(hash).valid?
  end

end
