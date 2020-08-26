class StudentRegistrationForm

  include ActiveModel::Model

  validates :name,
            presence: true

  validates :competition_token,
            presence: true

  validates :password,
            presence: true,
            length: { within: 8..40 },
            confirmation: true

  validates :email,
            presence: true,
            format: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  validate  :verify_unique_email

  validate  :verify_competition_exists

  attr_accessor :competition_token,
                :name,
                :email,
                :password,
                :password_confirmation

  def initialize(params = {})
    self.competition_token = params[:competition_token]
    self.name = params[:name]
    self.email = params[:email]
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
  end

  def competition
    Competition.find_by(token: competition_token)
  end

  protected

    def verify_unique_email
      if Student.exists?(email: email)
        errors.add :email, 'has already been taken'
      end
    end

    def verify_competition_exists
      errors.add(:base, 'Not a valid competition') unless competition
    end

end