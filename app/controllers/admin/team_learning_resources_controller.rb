class Admin::TeamLearningResourcesController < AdminController

  before_action :require_admin

  def show
    @team_learning_resource = TeamLearningResource.find(params[:id])

    unless authorized?(current_admin, @team_learning_resource)
      not_found and return
    end
  end

  private

    def authorized?(instructor, team_learning_resource)
      team_learning_resource.team.competition.instructor == instructor
    end

end