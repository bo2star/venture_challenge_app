class AddIsPublishedToLearningResources < ActiveRecord::Migration
  def change
    add_column :learning_resources, :is_published, :boolean, default: false
  end
end
