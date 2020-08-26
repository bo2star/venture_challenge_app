class Student::CompetitionsController < StudentController

  before_action :require_student
  before_action :require_team

  def show
    @competition = current_competition
  end

  def history
    @competition = current_competition
  end

end