class IncreaseSizeOfReferralUrl < ActiveRecord::Migration
  def change
    remove_column :referrals, :url
    add_column :referrals, :url, :text
  end
end
