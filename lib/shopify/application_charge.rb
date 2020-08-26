module Shopify
class ApplicationCharge

  def initialize(shopify_hash)
    @hash = shopify_hash
  end

  def id
    @hash['id'].to_s
  end

  def status
    @hash['status']
  end

  def confirmation_url
    @hash['confirmation_url']
  end

  def return_url
    @hash['return_url']
  end

  def name
    @hash['name']
  end

  def accepted?
    status == 'accepted'
  end

end
end