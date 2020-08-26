class AddIsPendingToShopRequests < ActiveRecord::Migration
  def change
    add_column :shop_requests, :is_pending, :boolean, default: true
  end
end
