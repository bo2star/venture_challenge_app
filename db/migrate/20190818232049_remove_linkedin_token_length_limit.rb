class RemoveLinkedinTokenLengthLimit < ActiveRecord::Migration
  def change
    change_column :students, :linkedin_token, :text
  end
end
