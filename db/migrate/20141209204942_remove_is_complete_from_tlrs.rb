class RemoveIsCompleteFromTlrs < ActiveRecord::Migration
  def change
    remove_column :team_learning_resources, :is_complete
  end
end
