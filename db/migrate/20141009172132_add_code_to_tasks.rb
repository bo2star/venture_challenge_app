class AddCodeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :code, :string
  end
end
