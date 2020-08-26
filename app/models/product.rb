# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  shop_id       :integer          indexed
#  uid           :string(255)
#  name          :string(255)
#  quantity      :integer
#  total_revenue :float
#  unit_cost     :float
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_products_on_shop_id  (shop_id)
#

class Product < ActiveRecord::Base
  belongs_to :shop

  scope :with_cost, -> { where.not(unit_cost: nil) }

  def total_cost
    quantity * unit_cost
  end

end
