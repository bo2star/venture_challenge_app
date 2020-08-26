require 'test_helper'

class CreateTeamTest < ActiveSupport::TestCase

  def setup
    comp = competitions(:killer_league)
    @team = CreateTeam.call(comp, 'New Team')
  end

  test 'creates a team' do
    assert Team, @team.class
    assert @team.persisted?
    assert @team.name == 'New Team'
  end

  test 'creates learning resources for each published learning resource' do
    resources = @team.learning_resources

    assert_equal 1, resources.size
    assert_equal 'Title 2', resources.first.title
  end

  test 'assigns a color to the team' do
    assert_equal String, @team.color.class
    assert CreateTeam::COLORS.include?(@team.color)
  end

end
