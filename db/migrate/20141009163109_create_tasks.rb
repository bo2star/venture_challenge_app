class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :points
      t.integer :priority
      t.string :badge
      t.integer :kind, default: 0

      t.timestamps
    end
  end
end
