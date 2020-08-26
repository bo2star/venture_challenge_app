class AddIsDeletedToLearningResources < ActiveRecord::Migration
  def change
    add_column :learning_resources, :is_deleted, :boolean, default: false
  end
end
