class CreateLearningResourceResponses < ActiveRecord::Migration
  def change
    create_table :learning_resource_responses do |t|
      t.references :learning_resource, index: true
      t.references :team, index: true
      t.boolean :is_complete, default: false

      t.timestamps
    end
  end
end
