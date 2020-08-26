class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.references :team, index: true
      t.string :name
      t.string :url
      t.datetime :webhooks_last_checked_at

      t.timestamps
    end

    add_index :shops, :url, unique: true
  end
end
