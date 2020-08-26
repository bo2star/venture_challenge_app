class TeamLearningResourceAnswerSerializer < ActiveModel::Serializer

  attributes :id, :body, :student_name, :created_at

  def student_name
    object.student && object.student.name
  end

  def created_at
    object.created_at.to_i * 1000
  end

end