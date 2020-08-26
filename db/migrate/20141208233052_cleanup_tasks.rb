class CleanupTasks < ActiveRecord::Migration
  def change
    [:team_learning_resource_id, :type, :min_sales, :min_referrals, :referral_pattern].each do |c|
      remove_column :tasks, c
    end
  end
end
