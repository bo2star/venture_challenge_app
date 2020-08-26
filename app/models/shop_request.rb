# == Schema Information
#
# Table name: shop_requests
#
#  id               :integer          not null, primary key
#  team_id          :integer          indexed
#  name             :string(255)
#  url              :string(255)
#  shopify_uid      :string(255)
#  shopify_token    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  confirmation_url :text
#  is_pending       :boolean          default("true")
#
# Indexes
#
#  index_shop_requests_on_team_id  (team_id)
#

class ShopRequest < ActiveRecord::Base

  belongs_to :team

  scope :pending, -> { where(is_pending: true) }

  def complete
    update!(is_pending: false)
  end

end
