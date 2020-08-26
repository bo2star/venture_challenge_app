class AddConfirmationUrlToShopRequests < ActiveRecord::Migration
  def change
    add_column :shop_requests, :confirmation_url, :text
  end
end
