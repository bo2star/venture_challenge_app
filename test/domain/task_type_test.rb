require_relative '../test_helper'

class TaskTypeTest < ActiveSupport::TestCase

  test 'computes the right code' do
    { 'twitter' => :referral,
      'launch' => :launch,
      'charitably_savvy' => :url_submission }.each do |code, expected_type|
        assert_equal expected_type, TaskType.new(code).type
    end
  end

  test 'allows querying by code' do
    assert TaskType.new('twitter').referral?
    assert_not TaskType.new('twitter').revenue?

    assert TaskType.new('learning_resource').learning_resource?
    assert_not TaskType.new('learning_resource').text_submission?
  end

  test 'raises an exception for an invalid code' do
    assert_raises TaskType::InvalidCodeError do
      TaskType.new('invalid').type
    end
  end

end