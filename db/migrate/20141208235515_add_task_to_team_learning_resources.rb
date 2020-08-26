class AddTaskToTeamLearningResources < ActiveRecord::Migration
  def change
    add_reference :team_learning_resources, :task, index: true
    remove_column :team_learning_resources, :learning_resource_id
  end
end
