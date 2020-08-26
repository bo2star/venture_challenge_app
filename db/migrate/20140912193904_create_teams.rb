class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :competition, index: true
      t.string :name

      t.timestamps
    end
  end
end
