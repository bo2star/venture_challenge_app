require 'test_helper'

class TeamLearningResourceTest < ActiveSupport::TestCase

  test 'next and previous' do
    one = team_learning_resources(:one)
    two = team_learning_resources(:two)

    assert_equal two, one.next
    assert_equal nil, two.next

    assert_equal one, two.previous
    assert_equal nil, one.previous
  end

end
