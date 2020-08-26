class AdminRegistrationForm

  include ActiveModel::Model

  validates :name,
            presence: true

  validates :password,
            presence: true,
            length: { within: 8..40 },
            confirmation: true

  validates :email,
            presence: true,
            format: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  validate  :verify_unique_email

  attr_accessor :name,
                :email,
                :password,
                :password_confirmation

  def initialize(params = {})
    self.name = params[:name]
    self.email = params[:email]
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
  end

  def instructor_params
    { name: name, email: email, password: password }
  end

  protected

    def verify_unique_email
      if Instructor.exists?(email: email)
        errors.add :email, 'has already been taken'
      end
    end

end