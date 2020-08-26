class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references :shop, index: true
      t.string :uid
      t.string :email
      t.datetime :acquired_at

      t.timestamps
    end

    add_index :customers, :uid, unique: true
  end

end
