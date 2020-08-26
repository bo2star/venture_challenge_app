class SynchronizeTeamJob
  include SuckerPunch::Job

  def perform(team_id)
    ActiveRecord::Base.connection_pool.with_connection do
      team = Team.find(team_id)
      SynchronizeTeam.call(team)
    end
  end

end