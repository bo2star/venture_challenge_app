class CompetitionSeeder
  extend Service

  MAX_SKILL = 10.0

  FAKE_PASSWORD = 'password'

  def initialize(num_teams: 7)
    @num_teams = num_teams
  end

  def seed_instructor
    RegisterInstructor.call( name: '[Seed] ' + Faker::Name.name,
                             email: Faker::Internet.email,
                             phone: Faker::PhoneNumber.phone_number,
                             password: FAKE_PASSWORD,
                             is_seeded: true )
  end

  def seed_competition(instructor, name: nil)
    student_seeder = StudentSeeder.new

    competition = seed_empty_competition(instructor, name: name)

    @num_teams.times do |i|
      seed_team(competition, student_seeder)
    end

    competition

  rescue StandardError => e
    # NOTE: This whole method *should* be wrapped in a transaction
    # so that everything is cleaned up if something goes wrong, but
    # it takes up to 30 seconds to run, and that sometimes causes
    # the PG transaction to timeout "PG::TRDeadlockDetected".
    # Could probably increase the timeout somehow. This is a quick
    # fix. Ideally we should speed this process up!
    competition.destroy!
    raise e
  end

  def seed_empty_competition(instructor, name: nil)
    name ||= "[Seed] Competition #{instructor.competitions.size + 1}"

    Competition.create!( instructor: instructor,
                         name: name,
                         start_date: 15.days.ago,
                         end_date: 15.days.from_now,
                         is_seeded: true )
  end

  def seed_team(competition, student_seeder = StudentSeeder.new)
    name = Faker::Company.name
    team = CreateTeam.call(competition, name)

    # 2-4 students
    student_count = rand(3) + 2

    students = (0...student_count).map {
      student_seeder.seed(competition, team)
    }

    # 66% of teams have a shop
    seed_shop(team) if rand(4) > 0

    SynchronizeTeamTasks.call(team)

    # Randomly complete some url_submission tasks.
    TaskType.codes_for(:url_submission).each do |code|
      # 15% chance of completing each task.
      team.task_with_code(code).complete(Faker::Internet.url) if rand(6) == 0
    end

    # Randomly complete some learning resources.
    team.learning_resources.each do |lr|
      # 20% chance of completing the learning resource.
      lr.task.complete if rand(5) == 0

      # 20% chance of completing each lr task.
      lr.tasks.each do |task|
        task.complete if rand(5) == 0
      end

      # 10% chance of each student answering each lr question.
      lr.questions.each do |question|
        students.each do |student|
          question.answer(Faker::Lorem.paragraph, student) if rand(10) == 0
        end
      end

    end

    team.update!(cached_total_points: team.total_points)
  end

  def seed_shop(team)
    shop = seed_empty_shop(team)

    skill = ((MAX_SKILL - 1) * rand) + 1

    start_date = team.competition.start_date.to_date
    end_date = Date.today

    (start_date..end_date).each do |day|
      seed_shop_orders(shop, day, skill)
    end
  end

  def seed_empty_shop(team)
    subdomain = team.name.downcase.split.join('-') + '-' + Faker::Internet.domain_word
    url = "http://#{subdomain}.myshopify.com"

    Shop.create!(team: team, name: team.name, url: url)
  end

  def seed_shop_orders(shop, day, skill)
    # Up to 7 orders for a max skill team.
    order_count = (7 * rand * skill / MAX_SKILL).to_i

    # Up to order_count customers.
    customer_count = rand(order_count) + 1

    customer_uids = (0...customer_count).map { fake_uid }

    order_count.times do
      # Up to $100 price.
      price = 100.0 * rand
      order = Order.create!( shop: shop,
                             uid: fake_uid,
                             placed_at: fake_time(day),
                             customer_uid: customer_uids.sample,
                             subtotal_price: price,
                             total_tax: 0,
                             total_discounts: 0,
                             total_price: price )

      Referral.create!(order: order, url: Faker::Internet.url)
    end

    customer_uids.each do |uid|
      Customer.create!( shop: shop,
                        uid: uid,
                        email: Faker::Internet.email,
                        acquired_at: fake_time(day) )
    end
  end

  private

    def fake_time(day)
      day + rand(24).hours
    end

    def fake_uid
      Faker::Number.number(10)
    end

end