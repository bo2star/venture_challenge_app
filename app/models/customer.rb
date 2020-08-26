# == Schema Information
#
# Table name: customers
#
#  id          :integer          not null, primary key
#  shop_id     :integer          indexed
#  uid         :string(255)      indexed
#  email       :string(255)
#  acquired_at :datetime
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_customers_on_shop_id  (shop_id)
#  index_customers_on_uid      (uid) UNIQUE
#

class Customer < ActiveRecord::Base

  belongs_to :shop

  scope :group_by_acquisition_day, -> { group('acquired_at::date') }

  def orders
    @orders ||= Order.where(customer_uid: uid)
  end

  def returning?
    orders.size > 1
  end

end