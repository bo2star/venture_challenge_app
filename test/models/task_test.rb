require 'test_helper'

class TaskTest < ActiveSupport::TestCase

  test 'complete' do
    task = tasks(:launch)
    assert_not task.complete?

    task.complete
    assert task.complete?
  end

end
