class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :order, index: true
      t.string :uid
      t.float :price
      t.integer :quantity
      t.string :product_uid
      t.string :sku
      t.string :title
      t.string :name

      t.timestamps
    end
  end
end
