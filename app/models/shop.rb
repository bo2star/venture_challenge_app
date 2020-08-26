# == Schema Information
#
# Table name: shops
#
#  id                       :integer          not null, primary key
#  team_id                  :integer          indexed
#  name                     :string(255)
#  url                      :string(255)      indexed
#  webhooks_last_checked_at :datetime
#  created_at               :datetime
#  updated_at               :datetime
#  shopify_uid              :string(255)      indexed
#  shopify_token            :string(255)
#
# Indexes
#
#  index_shops_on_shopify_uid  (shopify_uid) UNIQUE
#  index_shops_on_team_id      (team_id)
#  index_shops_on_url          (url) UNIQUE
#

class Shop < ActiveRecord::Base

  belongs_to :team
  has_many :orders, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :products, dependent: :destroy

  def last_acquired_customer
    customers.order(acquired_at: :desc).first
  end

  def last_placed_order
    orders.order(placed_at: :desc).first
  end

  def customers_acquired_during(date_range)
    customers.where(acquired_at: date_range.to_range)
  end

  def orders_placed_during(date_range)
    orders.where(placed_at: date_range.to_range)
  end

  def referrals_during(date_range)
    Referral.for_orders( orders_placed_during(date_range) )
  end

  def referrals
    Referral.for_orders(orders)
  end

  def line_items
    LineItem.where(order_id: order_ids)
  end

  def fake?
    !shopify_uid || !shopify_token
  end

  def pending_products
    products.where(unit_cost: nil)
  end

end

class << Shop

  def unique_uid?(shopify_uid)
    !ShopRequest.pending.exists?(shopify_uid: shopify_uid) && !Shop.exists?(shopify_uid: shopify_uid)
  end

end

