# == Schema Information
#
# Table name: team_comments
#
#  id           :integer          not null, primary key
#  body         :text
#  creator_id   :integer
#  creator_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  team_id      :integer          indexed
#
# Indexes
#
#  index_team_comments_on_team_id  (team_id)
#

class TeamComment < ActiveRecord::Base
  belongs_to :team
  belongs_to :creator, polymorphic: true
end
