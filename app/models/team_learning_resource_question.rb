# == Schema Information
#
# Table name: team_learning_resource_questions
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  order                     :integer          default("0")
#  team_learning_resource_id :integer
#  created_at                :datetime
#  updated_at                :datetime
#

class TeamLearningResourceQuestion < ActiveRecord::Base

  include Sortable

  belongs_to :learning_resource, class_name: 'TeamLearningResource'
  has_many :answers, class_name: 'TeamLearningResourceAnswer', foreign_key: 'question_id', dependent: :destroy

  def answer(body, student)
    answers.create!(body: body, student: student)
  end

end
