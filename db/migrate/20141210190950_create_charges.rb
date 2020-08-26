class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.references :shop, index: true
      t.string :uid

      t.timestamps
    end
  end
end
