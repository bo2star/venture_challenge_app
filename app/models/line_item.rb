# == Schema Information
#
# Table name: line_items
#
#  id          :integer          not null, primary key
#  order_id    :integer          indexed
#  uid         :string(255)
#  price       :float
#  quantity    :integer
#  product_uid :string(255)
#  sku         :string(255)
#  title       :string(255)
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_line_items_on_order_id  (order_id)
#

class LineItem < ActiveRecord::Base
  belongs_to :order

  scope :paid, -> { joins(:order).merge(Order.paid) }

  def total_price
    quantity * price
  end

  def revenue
    # The revenue earned from a line item is more complicated than
    # you'd expect. The order can have discounts, taxes, and shipping
    # fees, which are not deducted from the line items themselves.
    # We can compute a "good-enough" revenue for a line item as the
    # fraction this line item comprises of the order, multiplied by
    # the subtotal_price of the order.
    total_line_item_price = order.line_items.map(&:total_price).sum
    return 0 if total_line_item_price == 0

    (total_price / total_line_item_price) * order.subtotal_price
  end



end
