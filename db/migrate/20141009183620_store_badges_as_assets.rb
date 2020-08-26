class StoreBadgesAsAssets < ActiveRecord::Migration
  def change
    remove_column :tasks, :badge
    remove_column :tasks, :badge_url
  end
end
