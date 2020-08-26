class RemoveKindFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :kind
  end
end
