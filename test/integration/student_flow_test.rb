require 'test_helper'

class StudentFlowTest < ActionDispatch::IntegrationTest

  include Capybara::DSL

  def setup
    mock_authentication
  end

  test 'student flow' do
    follow_join_link

    join_competition

    create_a_team

    launch_shop

    view_tasks

    view_learning_resource

    view_leaderboard

    log_out

    log_in
  end

  def mock_authentication
    OmniAuth.config.test_mode = true

    OmniAuth.config.add_mock(:linkedin, {
      credentials: { token: '1111' },
      info: {
        first_name: 'Mitch',
        last_name: 'Crowe',
        email: 'my.email@gmail.com'
      }
    })

    OmniAuth.config.add_mock(:shopify, {
      uid: 'shoes-for-humanity.myshopify.com',
      credentials: { token: '2c0887bb02f475d7887c6d613ff1b337' },
      info: {
        url: 'shoes-for-humanity.myshopify.com',
      }
    })
  end

  def follow_join_link
    competition = competitions(:killer_league)

    visit competition.decorate.join_url

    assert_content('Killer League')
    assert_content('a VentureChallenge competition')
  end

  def join_competition
    click_link 'Join'

    # See the team forming page.
    assert_content('Welcome, Mitch! To get started, you need a team.')
  end

  def create_a_team
    fill_in 'Name', with: 'Mitchs Team'
    click_button 'Start team'

    # See your team's empty dashboard.
    assert_content('Mitchs Team')
    assert_content('Leave and delete this team')
    assert_content('Getting Started')
  end

  def launch_shop
    fill_in 'shop_form[url]', with: 'shoes-for-humanity.myshopify.com'

    # We need to stub out posting the application charge, and fake the response when fetching the application
    # charge.
    app_charge = OpenStruct.new(confirmation_url: "/shop_confirmation_callback?charge_id=701373", id: 701373)

    PostApplicationCharge.stub :call, app_charge do
      VCR.use_cassette 'student_flow' do
        click_button 'Launch'
      end
    end

    # Shop has been launched.
    assert_content("Your shop 'Shoes For Humanity' has been launched.")
  end

  def view_tasks
    click_link 'Tasks'

    assert_content('Improve your store and earn extra points for your team by completing these tasks.')
    ['PR Genius', 'Charitably Savvy'].each do |task_name|
      assert_content(task_name)
    end
  end

  def view_learning_resource
    click_link 'View'

    assert_content('Title 2')
    assert_content('Body 2')
    assert_content('Submit to Instructor')
  end

  def view_leaderboard
    click_link 'Leaderboard'

    assert_content('Overview')
    assert_content('History')
    assert_content('This competition is over.')
  end

  def log_out
    click_link 'nav-item-logout'

    assert_content('Please log in with LinkedIn to access your competition.')
  end

  def log_in
    click_link 'Log In'

    assert_content('Mitchs Team')
  end

  def assert_content(content)
    assert page.has_content?(content)
  end

end
