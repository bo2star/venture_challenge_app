namespace :competitions do

  desc 'Seed a fully-filled competition for an existing or a new instructor'
  task :seed => :environment do
    puts "To seed a competition for an existing instructor, enter their email now. To create a new instructor, hit enter."
    email = STDIN.gets.chomp

    seeder = CompetitionSeeder.new(num_teams: 25)

    instructor = Instructor.find_by(email: email) || seeder.seed_instructor

    competition = seeder.seed_competition(instructor)

    puts "Seeded instructor '#{email}' with competition '#{competition.name}'."
  end



end