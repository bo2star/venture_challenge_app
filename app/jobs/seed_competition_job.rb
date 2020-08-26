class SeedCompetitionJob
  include SuckerPunch::Job

  def perform(instructor_id, name: nil)
    ActiveRecord::Base.connection_pool.with_connection do
      instructor = Instructor.find(instructor_id)
      CompetitionSeeder.new.seed_competition(instructor, name: name)
    end
  end

end