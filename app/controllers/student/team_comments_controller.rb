class Student::TeamCommentsController < StudentController

  before_action :require_student
  before_action :require_team

  def index
    comments_json = current_team.team_comments.map { |c|
      {id: c.id, body: c.body, creator_name: c.creator.name, created_at: c.created_at.to_i * 1000 }
    }
    render json: comments_json
  end

  def create
    current_team.team_comments.create!(body: params[:body], creator: current_student)
    head :ok
  end

end