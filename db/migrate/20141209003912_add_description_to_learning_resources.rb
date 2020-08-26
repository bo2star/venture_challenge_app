class AddDescriptionToLearningResources < ActiveRecord::Migration
  def change
    add_column :learning_resources, :description, :text
  end
end
