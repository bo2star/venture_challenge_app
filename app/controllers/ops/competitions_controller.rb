class Ops::CompetitionsController < OpsController

  def index
    @competitions = Competition.order(created_at: :desc)

  end

  def show
    @competition = find_competition
  end

  def seed_student
    competition = find_competition

    # Create a student without a team in the current competition.
    student = StudentSeeder.new.seed(competition)

    redirect_to [:ops, competition], notice: "Seeded new student '#{student.name}' without a team"
  end

  def destroy
    competition = find_competition

    competition.destroy!

    redirect_to [:ops, competition.instructor], notice: 'Competition deleted'
  end

  private

    def find_competition
      Competition.find(params[:id])
    end

end
