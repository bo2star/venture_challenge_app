class Admin::LearningResourceQuestionsController < AdminController

  before_action :require_admin

  def index
    @resource = find_learning_resource
    render json: @resource.questions.sorted
  end

  def create
    @resource = find_learning_resource
    question = @resource.questions.build_at_end(title: params[:title])
    question.save!

    render json: question
  end

  def destroy
    @resource = find_learning_resource
    question = @resource.questions.find(params[:id])
    question.destroy!
    head :ok
  end

  def sort
    @resource = find_learning_resource
    @resource.questions.sort(params[:ordered_ids])
    head :ok
  end

  private

    def find_learning_resource
      current_admin.learning_resources.find(params[:learning_resource_id])
    end

end