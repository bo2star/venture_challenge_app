class Student::TeamsController < StudentController

  before_action :require_student
  before_action :require_no_team, only: [:new, :create]
  before_action :require_team,    only: [:show, :destroy]

  def new
    @form = TeamForm.new(current_competition)
  end

  def create
    @form = TeamForm.new(current_competition, name: params[:team_form][:name])

    if @form.valid?
      team = CreateTeam.call(@form.competition, @form.name)
      current_student.join_team(team)
      redirect_to team_path
    else
      render :new
    end
  end

  def show
  end

  def destroy
    current_team.destroy!
    redirect_to new_team_membership_path, notice: "Your team has been deleted."
  end

end