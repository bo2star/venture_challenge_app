class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :shop, index: true
      t.string :uid
      t.string :name
      t.integer :quantity
      t.float :total_revenue
      t.float :unit_cost

      t.timestamps
    end
  end
end
