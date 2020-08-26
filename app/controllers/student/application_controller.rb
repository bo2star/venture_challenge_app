class StudentController < ::ApplicationController

  include Student::Authentication

  protected

    def current_competition
      current_student && current_student.competition
    end
    helper_method :current_competition

    def current_team
      current_student && current_student.team
    end
    helper_method :current_team

    def require_team
      redirect_to(new_team_membership_path) unless current_team
    end

    def require_no_team
      redirect_to(team_path) if current_team
    end

end
