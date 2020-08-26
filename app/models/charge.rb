# == Schema Information
#
# Table name: charges
#
#  id           :integer          not null, primary key
#  shop_id      :integer          indexed
#  uid          :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  activated_at :datetime
#
# Indexes
#
#  index_charges_on_shop_id  (shop_id)
#

class Charge < ActiveRecord::Base
  belongs_to :shop

  scope :unactivated, -> { where(activated_at: nil) }

  def activate
    touch(:activated_at)
  end
end
