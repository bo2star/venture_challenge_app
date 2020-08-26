class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.references :team, index: true
      t.string :name
      t.float :amount

      t.timestamps
    end
  end
end
