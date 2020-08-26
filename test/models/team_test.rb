require 'test_helper'

class TeamTest < ActiveSupport::TestCase

  def setup
    @team = teams(:bobs_team)
  end

  def add_profit(team)
    @team.products.create!(uid: 1, unit_cost: 5, quantity: @team.orders.size * 2)
    @team.products.create!(uid: 2, quantity: @team.orders.size * 3)

    @team.orders.each do |order|
      order.line_items.create!(product_uid: 1, price: 10, quantity: 2)
      order.line_items.create!(product_uid: 2, price: 20, quantity: 3)
    end
  end

  test 'only_member?' do
    bob = students(:bob)

    refute @team.only_member?(bob)

    bob.join_team(@team)

    assert @team.reload.only_member?(bob)

    students(:shirley).join_team(@team)

    refute @team.reload.only_member?(bob)
  end

  test 'total_customers' do
    assert_equal 3, @team.total_customers
  end

  test 'total_orders' do
    assert_equal 13, @team.total_orders
  end

  test 'total_revenue' do
    assert_equal 267.0, @team.total_revenue
  end

  test 'profit' do
    assert_equal 0, @team.total_profit
    assert_equal([0] * 18, @team.daily_profit.cumulative_over(@team.report_range))
    assert_equal 297, @team.total_points
    dp = [0, 0, 0, 38, 38, 38, 132, 132, 132, 172, 172, 172, 242, 242, 297, 297, 297, 297]
    assert_equal(dp, @team.daily_points.cumulative_over(@team.report_range))

    add_profit(@team)

    # We should earn profit only for product 1, because it has a unit_cost.
    expected_profit = 137
    assert_equal expected_profit, @team.total_profit    

    expected = [0.0, 0.0, 0.0, 18.0, 18.0, 18.0, 102.0, 102.0, 102.0, 102.0, 102.0, 102.0, 102.0, 102.0, 137.0, 137.0, 137.0, 137.0]
    assert_equal(expected, @team.daily_profit.cumulative_over(@team.report_range))

    assert_equal 297 + 2*expected_profit, @team.total_points

    dp = [0.0, 0.0, 0.0, 74.0, 74.0, 74.0, 336.0, 336.0, 336.0, 376.0, 376.0, 376.0, 446.0, 446.0, 571.0, 571.0, 571.0, 571.0]
    assert_equal(dp, @team.daily_points.cumulative_over(@team.report_range))
  end

  test 'stats for a team with no shop' do
    team = teams(:steves_team)

    assert_equal 0, team.customers.size
    assert_equal 0, team.orders.size
    assert_equal 0, team.referrals.size

    assert_equal 0, team.total_customers
    assert_equal 0, team.total_orders
  end

  test 'daily_points' do
    expected = [0, 0, 0, 38, 38, 38, 132, 132, 132, 172, 172, 172, 242, 242, 297, 297, 297, 297]
    assert_equal(expected, @team.daily_points.cumulative_over(@team.report_range))
  end

  test 'total_points' do
    assert_equal 297, @team.total_points
  end

  test "destroying should clear all student's team" do
    teams(:steves_team).destroy!
    assert_equal nil, students(:steve).team_id
  end

  test 'launched_shop?' do
    assert teams(:bobs_team).launched_shop?
  end

  test 'latest_pending_shop_request' do
    req = shop_requests(:one)

    assert_equal req, teams(:bobs_team).latest_pending_shop_request

    req.complete

    assert_equal nil, teams(:bobs_team).latest_pending_shop_request
  end

  test 'pending_shop_request?' do
    assert_not teams(:bobs_team).pending_shop_request?
  end

end