require 'test_helper'

class StudentTest < ActiveSupport::TestCase

  def setup
    @bob = students(:bob)
  end

  test 'join a competition' do
    competition = competitions(:killer_league)

    assert_equal nil, @bob.competition

    @bob.join_competition(competition)

    assert_equal competition, @bob.reload.competition
  end

  test 'team managements' do
    team = teams(:bobs_team)

    assert_equal nil, @bob.team
    refute @bob.has_team?

    @bob.join_team(team)

    assert_equal team, @bob.reload.team
    assert @bob.has_team?

    @bob.leave_team

    assert_equal nil, @bob.reload.team
    refute @bob.has_team?
  end

  test 'first_name' do
    assert_equal 'Bob', @bob.first_name
  end

end
