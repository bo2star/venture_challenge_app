class AssignLearningResourcesAndColorsToTeams < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      Team.find_each do |team|

        next unless team.competition && team.competition.instructor

        # Duplicate learning resources.
        team.competition.learning_resources.each do |lr|
          lr.duplicate_for_team(team)
        end

        # Assign a color.
        swatch = Swatch.new(CreateTeam::COLORS)
        used_colors = team.competition.teams.pluck(:color)
        color = swatch.least_used(used_colors)

        team.update!(color: color)

      end
    end
  end
end
