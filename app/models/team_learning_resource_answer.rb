# == Schema Information
#
# Table name: team_learning_resource_answers
#
#  id          :integer          not null, primary key
#  body        :text
#  student_id  :integer          indexed
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_team_learning_resource_answers_on_student_id  (student_id)
#

class TeamLearningResourceAnswer < ActiveRecord::Base

  belongs_to :student
  belongs_to :question, class_name: 'TeamLearningResourceQuestion'

end
