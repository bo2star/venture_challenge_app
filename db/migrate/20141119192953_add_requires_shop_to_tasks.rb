class AddRequiresShopToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :requires_shop, :boolean, default: false
  end
end
