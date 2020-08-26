class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.references :order, index: true
      t.string :url

      t.timestamps
    end
  end
end
