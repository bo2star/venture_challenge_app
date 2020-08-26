class Admin::LinkedinAuthenticationsController < AdminController

  # Handles logins and registrations through linkedin.
  #
  # If the credentials match an an existing user, then they are intending to log in.
  #
  def create
    auth = Linkedin::Authentication.new(env['omniauth.auth'])

    if instructor = Instructor.find_by(linkedin_uid: auth.uid)
      login(instructor)
    else
      register(auth)
    end
  end

  def destroy
    logout
    redirect_to '/'
  end

  # Something went wrong during linkedin authentication. Most likely the user canceled
  # the login.
  def failure
    redirect_to login_path, notice: "Sorry, something went wrong. Please try logging in again."
  end

  private

    def login(instructor)
      login_as(instructor)
      redirect_to '/'
    end

    def register(auth)
      instructor = RegisterInstructor.call( name: auth.name,
                                            email: auth.email,
                                            avatar_url: auth.image,
                                            linkedin_uid: auth.uid,
                                            linkedin_token: auth.token )
      login_as(instructor)
      redirect_to '/'
    end

end