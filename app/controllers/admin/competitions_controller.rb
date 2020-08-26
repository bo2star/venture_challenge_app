class Admin::CompetitionsController < AdminController

  before_action :require_admin
  before_action :find_competition, only: [:show, :leaderboard, :edit, :update, :destroy]

  def index
    @competitions = current_admin.competitions
  end

  def show
    @competition = find_competition
  end

  def leaderboard
    @competition = find_competition
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"Venture-Challenge-Team-Data-#{Time.current.to_formatted_s(:long_ordinal)}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def history
    @competition = find_competition
  end

  def new
    @competition = current_admin.competitions.build(start_date: Date.today, end_date: 1.month.from_now)
  end

  def create
    @competition = current_admin.competitions.build(competition_params)

    if @competition.save
      redirect_to [:admin, @competition], notice: "Successfully created competition '#{@competition.name}'."
    else
      render 'new'
    end
  end

  def edit
    @competition = find_competition
  end

  def update
    @competition = find_competition

    if @competition.update(competition_params)
      redirect_to [:edit, :admin, @competition], notice: "Successfully updated competition '#{@competition.name}'."
    else
      render 'edit'
    end
  end

  def destroy
    competition = find_competition

    competition.destroy!

    redirect_to admin_competitions_path, notice: "Deleted competition '#{competition.name}'."
  end

  def download_coursepack
    send_file(
      "#{Rails.root}/public/downloads/VentureChallengeCoursePack.zip",
      filename: "VentureChallengeCoursePack.zip",
      type: "application/zip"
    )
  end

  private

    def find_competition
      current_admin.competitions.find(params[:id])
    end

    def competition_params
      params.require(:competition).permit(:name, :start_date, :end_date, :message)
    end

end
