require 'test_helper'

class InstructorWithPasswordFlowTest < ActionDispatch::IntegrationTest

  include Capybara::DSL

  def setup
    Capybara.app_host = 'http://admin.test.host'
  end

  test 'student flow' do
    register_with_password
    log_out
    log_in_with_password
  end

  def register_with_password
    visit '/signup'
    click_link 'Not on LinkedIn?'

    assert_content("Welcome! Let's get started.")

    fill_in 'Name', with: 'Mitch Test'
    fill_in 'Email', with: 'bob@test.com'
    fill_in 'Password', with: 'password'
    fill_in 'Confirm Password', with: 'password'
    click_button 'Register'

    assert_content('Welcome Mitch')
  end

  def log_out
    click_link 'nav-item-logout'

    assert_content('Please log in with LinkedIn')
  end

  def log_in_with_password
    click_link 'Not on LinkedIn?'

    fill_in 'Email', with: 'bob@test.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    assert_content('Welcome Mitch')
  end

  def assert_content(content)
    assert page.has_content?(content), "Expected page to have content '#{content}'"
  end

end
