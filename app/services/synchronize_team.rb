# SynchronizeTeam
#
# Synchronizes a team's stats with any changes in the world. This is idempotent, so this task
# can be run repeatedly to ensure stats remain up to date.
#
# - If the team has a shop, then it order data is synchronized with shopify.
# - The team's tasks are synchronized to account for any they may have completed due to shop activity.
#
class SynchronizeTeam
  extend Service

  def initialize(team)
    @team = team
  end

  def call
    log("synchronizing team ##{@team.id}")
    synchronize_shop
    synchronize_tasks
    synchronize_cached_total_points
  end

  private

    def synchronize_shop
      if @team.shop
        log("synchronizing shop ##{@team.shop.id} for team ##{@team.id}")
        ShopSynchronizer.new(@team.shop).synchronize
      else
        log("no shop to synchronize")
      end
    end

    def synchronize_tasks
      SynchronizeTeamTasks.call(@team)
    end

    def synchronize_cached_total_points
      @team.update!(cached_total_points: @team.total_points)
    end

    def log(msg)
      Rails.logger.info("SynchronizeTeam: #{msg}")
    end

end