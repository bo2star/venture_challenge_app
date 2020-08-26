class Student::MembershipsController < StudentController

  before_action :require_student
  before_action :require_no_team, only: [:new, :create]
  before_action :require_team,    only: [:destroy]

  def new
    @competition = current_competition
  end

  def create
    team = current_competition.teams.find(params[:team_id])

    current_student.join_team(team)

    redirect_to team_path, notice: "You have joined #{team.name}."
  end

  def destroy
    current_student.leave_team

    redirect_to new_team_membership_path
  end

end