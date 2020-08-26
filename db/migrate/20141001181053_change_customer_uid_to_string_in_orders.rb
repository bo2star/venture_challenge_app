class ChangeCustomerUidToStringInOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :customer_uid
    add_column :orders, :customer_uid, :string
  end
end
