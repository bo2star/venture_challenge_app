class AddTeamIdToTeamComments < ActiveRecord::Migration
  def change
    add_reference :team_comments, :team, index: true, foreign_key: true
  end
end
