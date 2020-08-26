class CreateTeamLearningResourceTasks < ActiveRecord::Migration
  def change
    create_table :team_learning_resource_tasks do |t|
      t.string :title
      t.integer :order, default: 0
      t.boolean :is_complete
      t.references :team_learning_resource

      t.timestamps
    end
  end
end
