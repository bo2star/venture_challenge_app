class AddFinancialStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :financial_status, :string, default: 'paid'
  end
end
