class Student::TeamLearningResourcesController < StudentController

  before_action :require_student
  before_action :require_team

  def show
    @resource = find_resource
  end

  def update
    resource = find_resource
    resource.task.complete

    redirect_to resource, notice: 'Learning resource submitted successfully.'
  end

  protected

    def find_resource
      current_team.learning_resources.find(params[:id])
    end

end