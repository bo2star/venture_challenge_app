module Shopify
class Order

  def initialize(shopify_hash)
    @hash = shopify_hash
  end

  def uid
    @hash['id'].to_s
  end

  def created_at
    Time.zone.parse(@hash['created_at'])
  end

  def customer_uid
    @hash['customer'] && @hash['customer']['id'].to_s
  end

  def financial_status
    @hash['financial_status']
  end

  def referring_site
    @hash['landing_site']
  end

  def subtotal_price
    @hash['subtotal_price'].to_f
  end

  def total_tax
    @hash['total_tax'].to_f
  end

  def total_discounts
    @hash['total_discounts'].to_f
  end

  def total_price
    @hash['total_price'].to_f
  end

  def line_items
    @hash['line_items'].map { |li|
      {
        'uid' => li['id'],
        'price' => li['price'].to_f,
        'product_uid' => li['product_id'],
        'quantity' => li['quantity'],
        'sku' => li['sku'],
        'title' => li['title'],
        'name' => li['name']
      }
    }
  end

end
end