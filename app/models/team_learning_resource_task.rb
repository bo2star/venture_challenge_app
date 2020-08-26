# == Schema Information
#
# Table name: team_learning_resource_tasks
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  order                     :integer          default("0")
#  is_complete               :boolean
#  team_learning_resource_id :integer
#  created_at                :datetime
#  updated_at                :datetime
#

class TeamLearningResourceTask < ActiveRecord::Base

  include Sortable

  belongs_to :learning_resource, class_name: 'TeamLearningResource'

  def complete
    update!(is_complete: true)
  end

end
