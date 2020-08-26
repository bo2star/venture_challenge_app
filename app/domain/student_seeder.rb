class StudentSeeder

  FAKE_PASSWORD = 'password'

  def initialize
    @profiles = read_profiles.shuffle
    @index = 0
  end

  def seed(competition, team = nil)
    profile = next_profile

    name = profile[:name]
    avatar_url = profile[:avatar_url]

    Student.create!( competition: competition,
                     team: team,
                     name: name,
                     email: generate_email(name),
                     password: FAKE_PASSWORD,
                     avatar_url: avatar_url )
  end

  def generate_email(name)
    domain = %w(gmail.com hotmail.com rru.ca yahoo.ca ubc.ca sfu.ca)
    first, last = name.downcase.split

    "#{first}.#{last}@#{domain.sample}"
  end

  private

    def next_profile
      # Cycle through the profiles.
      profile = @profiles[@index]

      @index = @index + 1 >= @profiles.length ? 0 : @index + 1

      profile
    end

    def read_profiles
      Dir[Rails.root.join('public/fake_avatars/*')].map do |path|
        filename = path.split('/').last
        {
          name: filename.split('.jpg').first.titleize,
          avatar_url: "/fake_avatars/#{filename}"
        }
      end
    end

end