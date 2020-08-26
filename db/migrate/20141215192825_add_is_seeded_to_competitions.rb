class AddIsSeededToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :is_seeded, :boolean, default: false
  end
end
