class Ops::InstructorsController < OpsController

  def index
    @instructors = Instructor.all
  end

  def show
    @instructor = find_instructor
  end

  def assume
    session[:admin_id] = find_instructor.id
    redirect_to admin_competitions_url(subdomain: 'admin')
  end

  def seed_competition
    instructor = find_instructor

    SeedCompetitionJob.new.async.perform(instructor.id)

    redirect_to [:ops, instructor]
  end

  def create
    instructor = CompetitionSeeder.new.seed_instructor

    redirect_to ops_instructors_path, notice: "Instructor '#{instructor.name}' created."
  end

  def destroy
    instructor = find_instructor
    instructor.destroy!

    redirect_to ops_instructors_path, notice: "Instructor '#{instructor.name}' deleted."
  end

  private

    def find_instructor
      Instructor.find(params[:id])
    end

end