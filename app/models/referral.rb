# == Schema Information
#
# Table name: referrals
#
#  id         :integer          not null, primary key
#  order_id   :integer          indexed
#  created_at :datetime
#  updated_at :datetime
#  url        :text
#
# Indexes
#
#  index_referrals_on_order_id  (order_id)
#

class Referral < ActiveRecord::Base

  belongs_to :order

  def domain
    Addressable::URI.parse(url).host
  end

end

class << Referral

  def for_orders(orders)
    ids = orders.is_a?(Array) ? orders.map(&:id) : orders.pluck(:id)
    where(order_id: ids)
  end

  def with_url_including(str)
    where("url ILIKE '%#{str}%'")
  end

end