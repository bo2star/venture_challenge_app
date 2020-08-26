class SimplifyShopifyIndentities < ActiveRecord::Migration
  def change
    drop_table :shopify_identities

    add_column :shops, :shopify_uid, :string
    add_column :shops, :shopify_token, :string
    add_index  :shops, :shopify_uid, unique: true
  end
end
