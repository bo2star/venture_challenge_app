# SynchronizeTeamTasks
#
# Idempotent service that computes all the tasks that a team has satisfied, and
# ensures that they are all marked as complete.
#
# Run as often as required to ensure that a team's completed tasks are up to date.
#
class SynchronizeTeamTasks

  REVENUE_DATA = {
    'lemonade_stand'  => 500,
    'small_business'  => 1000,
    'medium_business' => 1500,
    'enterprise'      => 2000,
    'multi_national'  => 2500
  }

  # TODO: What do pinterest and instagram referral URLs look like?
  REFERRAL_DATA = {
    'twitter'   => { pattern: 'twitter'    , count: 3 },
    'facebook'  => { pattern: 'facebook'   , count: 3 },
    'pinterest' => { pattern: 'pinterest'  , count: 3 },
    'instagram' => { pattern: 'instagram'  , count: 3 },
    'sem'       => { pattern: 'google'     , count: 3 }
  }

  extend Service

  def initialize(team)
    @team = team
  end

  def call
    log("synchronizing tasks for team ##{@team.id}")

    complete('launch') if @team.launched_shop?

    # Check for referral-based completions
    REFERRAL_DATA.each do |code, data|
      complete(code) if referrals_matching(data[:pattern]) >= data[:count]
    end

    # Check for revenue-based completions
    revenue = @team.total_revenue

    REVENUE_DATA.each do |code, required_revenue|
      complete(code) if revenue > required_revenue
    end
  end

  private

    def complete(code)
      log("task #{code} is complete for team ##{@team.id}")
      @team.task_with_code(code).complete
    end

    def referrals_matching(string)
      @team.referrals.with_url_including(string).size
    end

    def log(msg)
      Rails.logger.info("SynchronizeTeamTasks: #{msg}")
    end

end
