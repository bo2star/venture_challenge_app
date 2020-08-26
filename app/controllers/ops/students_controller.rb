class Ops::StudentsController < OpsController

  def index
    @students = Student.joins(:competition).all
  end

  def assume
    student = Student.find(params[:id])
    session[:student_id] = student.id
    redirect_to team_url(subdomain: 'app')
  end

end