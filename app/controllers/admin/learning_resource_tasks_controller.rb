class Admin::LearningResourceTasksController < AdminController

  before_action :require_admin

  def index
    @resource = find_learning_resource
    render json: @resource.tasks.sorted
  end

  def create
    @resource = find_learning_resource
    task = @resource.tasks.build_at_end(title: params[:title])
    task.save!

    render json: task
  end

  def destroy
    @resource = find_learning_resource
    task = @resource.tasks.find(params[:id])
    task.destroy!
    head :ok
  end

  def sort
    @resource = find_learning_resource
    @resource.tasks.sort(params[:ordered_ids])
    head :ok
  end

  private

    def find_learning_resource
      current_admin.learning_resources.find(params[:learning_resource_id])
    end

end