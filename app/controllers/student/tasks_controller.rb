class Student::TasksController < StudentController

  before_action :require_student
  before_action :require_team

  def index
    @team = current_team
  end

  def update
    task = current_team.tasks.find(params[:id])
    task.complete(params[:task][:response])

    redirect_to tasks_path, notice: "Great job completing this task!"
  end

end