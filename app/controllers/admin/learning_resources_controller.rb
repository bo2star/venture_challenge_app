class Admin::LearningResourcesController < AdminController

  before_action :require_admin

  def index
    respond_to do |format|
      format.json { render json: current_admin.learning_resources.non_deleted.sorted }
      format.html {}
    end
  end

  def new
    @resource = current_admin.learning_resources.build
  end

  def create
    @resource = current_admin.learning_resources.build_at_end(learning_resource_params)

    if @resource.save
      redirect_to [:admin, @resource], notice: 'Learning resource successfully created.'
    else
      render :new
    end
  end

  def show
    @resource = find_learning_resource
  end

  def edit
    @resource = find_learning_resource
  end

  def update
    @resource = find_learning_resource

    if @resource.update(learning_resource_params)
      redirect_to [:admin, @resource], notice: 'Learning resource successfully updated.'
    else
      render :edit
    end
  end

  def publish
    resource = find_learning_resource
    resource.publish
    head :ok
  end

  def unpublish
    resource = find_learning_resource
    resource.unpublish
    head :ok
  end

  def sort
    current_admin.learning_resources.sort(params[:ordered_ids])
    head :ok
  end

  private

    def find_learning_resource
      current_admin.learning_resources.find(params[:id])
    end

    def learning_resource_params
      params.require(:learning_resource).permit(:title, :body, :video_url)
    end

end