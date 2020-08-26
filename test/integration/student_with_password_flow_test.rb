require 'test_helper'

class StudentWithPasswordFlowTest < ActionDispatch::IntegrationTest

  include Capybara::DSL

  test 'student with password flow' do
    follow_join_link
    join_competition_with_password
    log_out
    log_in_with_password
  end

  def follow_join_link
    competition = competitions(:killer_league)

    visit competition.decorate.join_url

    assert_content('Killer League')
    assert_content('a VentureChallenge competition')
  end

  def join_competition_with_password
    click_link 'Not on LinkedIn?'

    fill_in 'Name', with: 'Mitch Test'
    fill_in 'Email', with: 'bob@test.com'
    fill_in 'Password', with: 'password'
    fill_in 'Confirm Password', with: 'password'
    click_button 'Join'

    # See the team forming page.
    assert_content('Welcome, Mitch! To get started, you need a team.')
  end

  def log_out
    click_link 'nav-item-logout'

    assert_content('Please log in with LinkedIn to access your competition.')
  end

  def log_in_with_password
    click_link 'Not on LinkedIn?'

    fill_in 'Email', with: 'bob@test.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    assert_content('Welcome, Mitch!')
  end

  def assert_content(content)
    assert page.has_content?(content), "Expected page to have content '#{content}'"
  end

end