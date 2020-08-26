class CreateTeamLearningResourceAnswers < ActiveRecord::Migration
  def change
    create_table :team_learning_resource_answers do |t|
      t.text :body
      t.references :student, index: true
      t.integer :question_id

      t.timestamps
    end
  end
end
