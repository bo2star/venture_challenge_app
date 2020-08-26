class TrackTaskCompletionDate < ActiveRecord::Migration
  def change
    remove_column :tasks, :is_complete
    add_column :tasks, :completed_at, :datetime
  end
end
