require_relative '../test_helper'

class DailyMetricTest < ActiveSupport::TestCase

  test 'getting a value on a given date' do
    data = { 2.days.ago => 1, 1.day.ago => 2 }
    metric = DailyMetric.new(data)

    assert_equal 1, metric.on(2.days.ago)
    assert_equal 2, metric.on(1.day.ago)
    assert_equal 0, metric.on(Date.current)
  end

  test 'getting values over a date range' do
    data = { 2.days.ago => 1, 1.day.ago => 2 }
    metric = DailyMetric.new(data)

    range = DateRange.new(3.days.ago, Date.current)

    assert_equal [0, 1, 2, 0], metric.over(range)
  end

  test 'getting cumulative values over a date range' do
    data = { 2.days.ago => 1, 1.day.ago => 2 }
    metric = DailyMetric.new(data)

    range = DateRange.new(3.days.ago, 0.days.ago)

    assert_equal [0, 1, 3, 3], metric.cumulative_over(range)
  end

  test 'scaling a metric' do
    data = { 2.days.ago => 1, 1.day.ago => 2 }
    metric = DailyMetric.new(data)

    scaled = metric * 3

    assert_equal [3, 6, 0], scaled.over( DateRange.new(2.days.ago, Date.current) )
  end

  test 'adding two metrics' do
    data_1 = { 2.days.ago => 1, 1.day.ago => 2 }
    data_2 = { 3.days.ago => 5, 1.day.ago => 2, Date.current => 6 }

    sum = DailyMetric.new(data_1) + DailyMetric.new(data_2)

    assert_equal [5, 1, 4, 6], sum.over( DateRange.new(3.days.ago, Date.current) )
  end

end