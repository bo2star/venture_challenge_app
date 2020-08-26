# == Schema Information
#
# Table name: expenses
#
#  id         :integer          not null, primary key
#  team_id    :integer          indexed
#  name       :string(255)
#  amount     :float
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_expenses_on_team_id  (team_id)
#

class Expense < ActiveRecord::Base
  belongs_to :team
end
