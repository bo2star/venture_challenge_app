class CreateShopifyIdentities < ActiveRecord::Migration
  def change
    create_table :shopify_identities do |t|
      t.references :shop, index: true
      t.string :token

      t.timestamps
    end

    add_index :shopify_identities, :token, unique: true
  end
end
