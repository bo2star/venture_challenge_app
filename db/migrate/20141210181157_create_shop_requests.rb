class CreateShopRequests < ActiveRecord::Migration
  def change
    create_table :shop_requests do |t|
      t.references :team, index: true
      t.string :name
      t.string :url
      t.string :shopify_uid
      t.string :shopify_token

      t.timestamps
    end
  end
end
