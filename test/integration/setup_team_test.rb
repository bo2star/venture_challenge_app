require 'test_helper'

class SetupTeamTest < ActionDispatch::IntegrationTest

  SHOP_URL = 'shoes-for-humanity.myshopify.com'
  SHOP_UID = SHOP_URL
  SHOP_TOKEN = '2c0887bb02f475d7887c6d613ff1b337'

  test 'setting up a team' do
    instructor = RegisterInstructor.call( name: Faker::Lorem.name,
                                          email: Faker::Internet.email,
                                          phone: Faker::PhoneNumber.phone_number)

    competition = instructor.competitions.create!( name: Faker::Lorem.sentence,
                                                   start_date: Date.civil(2015, 1, 1),
                                                   end_date: Date.civil(2015, 2, 1) )

    student = competition.students.create!( name: Faker::Lorem.name,
                                            email: Faker::Internet.email )

    team = CreateTeam.call(competition, Faker::Lorem.sentence)

    # Synchronization should not fail before a shop is launched.
    SynchronizeTeam.call(team)

    assert_not team.task_with_code('launch').complete?
    assert_equal 0, team.total_points

    shop_request = ShopRequest.create!( team: team,
                                        name: team.name,
                                        url: SHOP_URL,
                                        shopify_uid: SHOP_UID,
                                        shopify_token: SHOP_TOKEN )

    LaunchShop.call(shop_request, '333')

    assert team.task_with_code('launch').complete?
    assert_equal team.name, team.shop.name
    assert_equal 10, team.total_points
    assert_equal 0, team.total_orders
    assert_equal 0, team.total_revenue
    assert_equal 0, team.total_customers

    SynchronizeTeam.call(team)

    assert_equal 20, team.total_points
    # This shop has one order, but it is not "paid", so doesn't
    # count.
    assert_equal 1, team.shop.orders.size
    assert_equal 'authorized', team.shop.orders.first.financial_status
    assert_equal 0, team.total_orders 
    assert_equal 0, team.total_revenue
    assert_equal 1, team.total_customers
  end

end