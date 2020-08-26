module Shopify
class Customer

  def initialize(shopify_hash)
    @hash = shopify_hash
  end

  def uid
    @hash['id'].to_s
  end

  def created_at
    Time.zone.parse(@hash['created_at'])
  end

  def email
    @hash['email']
  end

end
end