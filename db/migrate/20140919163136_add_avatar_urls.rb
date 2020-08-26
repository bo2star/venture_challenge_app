class AddAvatarUrls < ActiveRecord::Migration
  def change
    add_column :students, :avatar_url, :string
    add_column :instructors, :avatar_url, :string
  end
end
