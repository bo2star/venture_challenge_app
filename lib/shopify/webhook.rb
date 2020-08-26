module Shopify
class Webhook

  def initialize(shopify_hash)
    @hash = shopify_hash
  end

  def topic
    @hash['topic']
  end

  def address
    @hash['address']
  end

end
end