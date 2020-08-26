class CreateTeamComments < ActiveRecord::Migration
  def change
    create_table :team_comments do |t|
      t.text :body
      t.integer :creator_id
      t.string :creator_type

      t.timestamps null: false
    end
  end
end
