module Shopify
class Authentication

  def initialize(shopify_hash)
    @data = shopify_hash
  end

  def token
    @data['credentials']['token']
  end

  def uid
    @data['uid']
  end

  def url
    uid
  end

  def name
    uid.split('.').first.titlecase
  end

  def valid?
    @data.key?('uid') &&
      @data.key?('credentials') &&
      @data['credentials'].key?('token')
  end

end
end