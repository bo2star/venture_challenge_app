class AddIsSeededToInstructors < ActiveRecord::Migration
  def change
    add_column :instructors, :is_seeded, :boolean, default: false
  end
end
