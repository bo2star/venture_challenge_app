class Student::TeamLearningResourceTasksController < StudentController

  before_action :require_student
  before_action :require_team

  def index
    @resource = find_resource
    render json: @resource.tasks
  end

  def update
    @resource = find_resource
    task = @resource.tasks.find(params[:id])

    task.is_complete = params[:is_complete]
    task.save!

    head :ok
  end

  protected

    def find_resource
      current_team.learning_resources.find(params[:team_learning_resource_id])
    end

end