class SetDecimalPrecisions < ActiveRecord::Migration
  def change
    [:subtotal_price, :total_tax, :total_discounts, :total_price].each do |column|
      remove_column :orders, column
      add_column :orders, column, :decimal, precision: 8, scale: 2
    end
  end
end
