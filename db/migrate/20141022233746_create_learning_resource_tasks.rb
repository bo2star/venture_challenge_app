class CreateLearningResourceTasks < ActiveRecord::Migration
  def change
    create_table :learning_resource_tasks do |t|
      t.string :title
      t.integer :order, default: 0
      t.references :learning_resource, index: true

      t.timestamps
    end
  end
end
