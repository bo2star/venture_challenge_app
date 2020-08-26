# == Schema Information
#
# Table name: learning_resource_questions
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
#  index_learning_resource_questions_on_learning_resource_id  (learning_resource_id)
#

class LearningResourceQuestion < ActiveRecord::Base

  include Sortable

  belongs_to :learning_resource

end
