class AddCouponCodeToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :coupon_code, :string
  end
end
