class CreateLinkedinIdentities < ActiveRecord::Migration
  def change
    create_table :linkedin_identities do |t|
      t.references :owner, polymorphic: true, index: true
      t.string :uid
      t.string :token

      t.timestamps
    end

    add_index :linkedin_identities, :uid, unique: true
  end
end
