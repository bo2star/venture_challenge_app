class TemporarilyAddBadgeUrlToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :badge_url, :string
  end
end
