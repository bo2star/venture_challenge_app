require 'test_helper'

class InstructorFlowTest < ActionDispatch::IntegrationTest

  include Capybara::DSL

  def setup
    Capybara.app_host = 'http://admin.test.host'
    mock_authentication
  end

  test 'student flow' do
    register

    view_learning_resources

    create_learning_resource

    create_competition

    edit_competition

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
  end

  def register
    visit '/signup'

    assert_content("Welcome! Let's get started by registering with LinkedIn.")

    click_link 'Register'

    assert_content('Welcome Mitch Crowe')
  end

  def view_learning_resources
    click_link 'Learning Resources'

    assert_content('My Learning Resources')
  end

  def create_learning_resource
    click_link 'New learning resource'

    fill_in 'Title', with: 'First Resource'
    fill_in 'Body', with: 'The resource body'
    click_button 'Create learning resource'

    assert_content('Learning resource successfully created')
  end

  def create_competition
    click_link 'Competitions'

    click_link 'Create a competition'

    fill_in 'Name', with: 'First competition'
    fill_in 'Start date', with: '2015-01-01'
    fill_in 'Start date', with: '2015-02-01'
    click_button 'Create competition'

    assert_content("Successfully created competition 'First competition'")
    assert_content('First competition')
    assert_content('Invite your students')
  end

  def edit_competition
    click_link 'Settings'

    fill_in 'Name', with: 'Edited competition'
    click_button 'Save changes'

    assert_content("Successfully updated competition 'Edited competition'")
  end

  def view_leaderboard
    click_link 'Leaderboard'
    click_link 'History'
  end

  def log_out
    click_link 'nav-item-logout'

    assert_content('Please log in with LinkedIn')
  end

  def log_in
    click_link 'Log In'

    assert_content('My Competitions')
    assert_content('Edited competition')
  end


  def assert_content(content)
    assert page.has_content?(content)
  end

end
