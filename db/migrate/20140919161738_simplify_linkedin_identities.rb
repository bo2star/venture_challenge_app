class SimplifyLinkedinIdentities < ActiveRecord::Migration
  def change
    drop_table :linkedin_identities

    add_column :instructors, :linkedin_uid, :string
    add_column :instructors, :linkedin_token, :string
    add_index  :instructors, :linkedin_uid, unique: true

    add_column :students, :linkedin_uid, :string
    add_column :students, :linkedin_token, :string
    add_index  :students, :linkedin_uid, unique: true
  end
end
