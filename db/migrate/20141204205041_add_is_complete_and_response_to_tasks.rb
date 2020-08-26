class AddIsCompleteAndResponseToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :is_complete, :boolean, default: false
    add_column :tasks, :response, :text
  end
end
