class AddCachedTotalPointsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :cached_total_points, :integer, default: 0
  end
end
