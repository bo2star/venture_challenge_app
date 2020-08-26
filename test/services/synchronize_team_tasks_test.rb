require 'test_helper'

class SynchronizeTeamTasksTest < ActiveSupport::TestCase
  test 'call' do
    team = teams(:bobs_team)

    launch_task = team.task_with_code('launch')

    assert_not launch_task.complete?

    SynchronizeTeamTasks.call(team)

    assert launch_task.reload.complete?
  end
end
