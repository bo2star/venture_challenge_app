# == Schema Information
#
# Table name: tasks
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text
#  points        :integer
#  priority      :integer
#  created_at    :datetime
#  updated_at    :datetime
#  code          :string(255)
#  requires_shop :boolean          default("false")
#  team_id       :integer          indexed
#  response      :text
#  completed_at  :datetime
#
# Indexes
#
#  index_tasks_on_team_id  (team_id)
#

class Task < ActiveRecord::Base

  belongs_to :team

  scope :shop_optional, -> { where.not(requires_shop: true) }
  scope :complete, -> { where.not(completed_at: nil) }
  scope :incomplete, -> { where(completed_at: nil) }
  scope :prioritized, -> { order(priority: :asc) }
  scope :group_by_completion_day, -> { group('completed_at::date') }
  scope :learning_resources, -> { where(code: 'learning_resource') }
  scope :other_tasks, -> { where.not(code: 'learning_resource') }

  def self.total_points
    all.sum('tasks.points')
  end

  def complete?
    completed_at != nil
  end

  def complete(response = nil)
    return if complete?
    self.completed_at = Time.now
    self.response = response
    save!
  end

  def type
    TaskType.new(code)
  end

  def learning_resource
    team.learning_resources.find_by(task: self)
  end

end
