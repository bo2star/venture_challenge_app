class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :shop, index: true
      t.string :uid
      t.decimal :subtotal_price
      t.decimal :total_tax
      t.decimal :total_discounts
      t.decimal :total_price
      t.datetime :placed_at
      t.integer :customer_uid

      t.timestamps
    end

    add_index :orders, :uid, unique: true
  end
end
