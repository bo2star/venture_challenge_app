require 'test_helper'

class SeedCompetitionTest < ActionDispatch::IntegrationTest

  test 'seeding a competition' do
    seeder = CompetitionSeeder.new

    instructor = seeder.seed_instructor

    competition = seeder.seed_competition(instructor)

    assert instructor.seeded?
    assert competition.seeded?
    assert competition.teams.size == 7
  end

end
