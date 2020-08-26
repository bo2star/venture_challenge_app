# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  shop_id          :integer          indexed
#  uid              :string(255)      indexed
#  placed_at        :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  subtotal_price   :decimal(8, 2)
#  total_tax        :decimal(8, 2)
#  total_discounts  :decimal(8, 2)
#  total_price      :decimal(8, 2)
#  customer_uid     :string(255)
#  financial_status :string           default("paid")
#
# Indexes
#
#  index_orders_on_shop_id  (shop_id)
#  index_orders_on_uid      (uid) UNIQUE
#

class Order < ActiveRecord::Base

  belongs_to :shop
  has_one :referral, dependent: :destroy
  has_many :line_items, dependent: :destroy

  scope :group_by_placement_day, -> { group('placed_at::date') }
  
  scope :paid, -> { where(financial_status: 'paid') }

end
