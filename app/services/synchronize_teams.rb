# SynchronizeTeams
#
# Convenience service to synchronize all teams for "live" (not seeded) and "active" (on-going)
# competitions.
#
class SynchronizeTeams
  extend Service

  def call
    log('synchronizing teams')

    Competition.live.active.each do |competition|
      log("synchronizing teams for competition ##{competition.id}")

      competition.teams.each do |team|
        SynchronizeTeam.call(team)
      end
    end

  end

  private

    def log(msg)
      Rails.logger.info("SynchronizeTeams: #{msg}")
    end

end