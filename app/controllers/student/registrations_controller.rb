class Student::RegistrationsController < StudentController

  # Form to join a competition with LinkedIn.
  #
  # Expects params[:token] to be the token of an existing competition.
  #
  def new
    # Log out in case the user is already logged in and tries to join a competition.
    # Not a common scenario, except in testing.
    logout

    @competition = Competition.find_by!(token: params[:token])

    # Remember the competition token so that it is available after Linkedin
    # authentication.
    session[:competition_token] = @competition.token
  end

  # Form to join a competition with email/password.
  #
  # Expects params[:token] to be the token of an existing competition.
  #
  def new_with_password
    # Log out in case the user is already logged in and tries to join a competition.
    # Not a common scenario, except in testing.
    logout

    @form = StudentRegistrationForm.new(competition_token: params[:token])

    # Forget the competition token since it isn't needed anymore for password
    # authentication, and might confuse us later.
    session[:competition_token] = nil
  end

  # Register and join the given competition using email/password.
  #
  def create
    form_params = params.require(:student_registration_form)

    @form = StudentRegistrationForm.new(form_params)

    if @form.valid?
      student = Student.create!( competition: @form.competition,
                                 name: @form.name,
                                 email: @form.email,
                                 password: @form.password )
      login_as(student)
      redirect_to new_team_membership_path
    else
      render :new_with_password
    end
  end

end