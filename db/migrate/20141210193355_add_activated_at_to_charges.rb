class AddActivatedAtToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :activated_at, :datetime
  end
end
