# == Schema Information
#
# Table name: learning_resource_tasks
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  order                :integer          default("0")
#  learning_resource_id :integer          indexed
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_learning_resource_tasks_on_learning_resource_id  (learning_resource_id)
#

class LearningResourceTask < ActiveRecord::Base

  include Sortable

  belongs_to :learning_resource

end
