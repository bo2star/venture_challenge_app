# == Schema Information
#
# Table name: team_learning_resources
#
#  id         :integer          not null, primary key
#  team_id    :integer          indexed
#  order      :integer          default("0")
#  title      :string(255)
#  body       :text
#  video_url  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  task_id    :integer          indexed
#
# Indexes
#
#  index_team_learning_resources_on_task_id  (task_id)
#  index_team_learning_resources_on_team_id  (team_id)
#

class TeamLearningResource < ActiveRecord::Base

  include Sortable

  belongs_to :team
  belongs_to :source, class_name: 'LearningResource', foreign_key: 'learning_resource_id'
  belongs_to :task

  has_many :tasks, class_name: 'TeamLearningResourceTask', dependent: :destroy
  has_many :questions, class_name: 'TeamLearningResourceQuestion', dependent: :destroy

  def previous
    team.learning_resources.find_by(order: order - 1)
  end

  def next
    team.learning_resources.find_by(order: order + 1)
  end

  def video_embed_url
    video_url.presence && Youtube::Video.parse(video_url).embed_url
  end

  def complete?
    task.complete?
  end

end
