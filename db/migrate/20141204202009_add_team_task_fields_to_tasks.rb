class AddTeamTaskFieldsToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :team, index: true
    add_reference :tasks, :team_learning_resource, index: true
    add_column :tasks, :type, :string
    add_column :tasks, :min_sales, :integer
    add_column :tasks, :min_referrals, :integer
    add_column :tasks, :referral_pattern, :string
  end
end
