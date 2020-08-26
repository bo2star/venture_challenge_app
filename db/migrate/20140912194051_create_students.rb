class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.references :competition, index: true
      t.references :team, index: true
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
