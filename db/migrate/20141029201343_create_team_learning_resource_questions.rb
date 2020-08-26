class CreateTeamLearningResourceQuestions < ActiveRecord::Migration
  def change
    create_table :team_learning_resource_questions do |t|
      t.string :title
      t.integer :order, default: 0
      t.references :team_learning_resource

      t.timestamps
    end
  end
end
