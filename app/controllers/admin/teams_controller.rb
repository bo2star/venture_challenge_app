class Admin::TeamsController < AdminController

  before_action :require_admin

  def show
    @team = Team.find(params[:id])
  end

end