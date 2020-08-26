class Student::TeamLearningResourceQuestionsController < StudentController

  before_action :require_student
  before_action :require_team

  def index
    @resource = find_resource
    render json: @resource.questions
  end

  def update
    @resource = find_resource
    question = @resource.questions.find(params[:id])

    question.answer(params[:answer], current_student)

    head :ok
  end

  protected

    def find_resource
      current_team.learning_resources.find(params[:team_learning_resource_id])
    end

end