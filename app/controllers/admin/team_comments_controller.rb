class Admin::TeamCommentsController < AdminController

  before_action :require_admin

  def index
    team = Team.find(params[:team_id])

    comments_json = team.team_comments.map { |c|
      {id: c.id, body: c.body, creator_name: c.creator.name, created_at: c.created_at.to_i * 1000 }
    }
    render json: comments_json
  end

  def create
    team = Team.find(params[:team_id])
    team.team_comments.create!(body: params[:body], creator: current_admin)
    head :ok
  end

end