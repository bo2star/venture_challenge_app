require 'test_helper'

class CompetitionTest < ActiveSupport::TestCase

  def setup
    @competition = competitions(:killer_league)
  end

  test 'generating a unique token' do
    competition = Competition.create!( name: 'Test',
                                       start_date: 1.month.ago,
                                       end_date: Date.today )

    assert competition.token.size > 4
  end

  test 'teamless_students' do
    assert_equal 0, @competition.teamless_students.size

    bob = students(:bob)
    bob.join_competition(@competition)

    assert_equal 1, @competition.teamless_students.size
  end

  test 'days_until_start' do
    assert_equal 0, @competition.days_until_start

    future_comp = Competition.new(name: 'future', start_date: 5.days.from_now, end_date: 30.days.from_now)

    assert_equal 5, future_comp.days_until_start
  end

  test 'started?' do
    assert @competition.started?

    future_comp = Competition.new(name: 'future', start_date: 5.days.from_now, end_date: 30.days.from_now)

    assert_not future_comp.started?
  end

end
