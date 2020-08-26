class ChangeTeamLearningResourceDefault < ActiveRecord::Migration
  def change
    change_column_default :team_learning_resources, :is_complete, false
  end
end
