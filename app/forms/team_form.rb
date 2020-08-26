class TeamForm
  include ActiveModel::Model

  attr_accessor :name, :competition

  validates_presence_of :name
  validate :require_unique_name

  def initialize(competition, name: nil)
    self.competition = competition
    self.name = name
  end

  protected

    def require_unique_name
      if competition.teams.exists?(name: name)
        errors.add :name, 'is already taken.'
      end
    end

end