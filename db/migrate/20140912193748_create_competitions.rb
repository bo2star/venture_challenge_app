class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.references :instructor, index: true
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.text :welcome_note
      t.string :token

      t.timestamps
    end
  end
end
