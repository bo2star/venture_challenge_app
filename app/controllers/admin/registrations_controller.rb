class Admin::RegistrationsController < AdminController

  # Form to register with LinkedIn.
  #
  def new
  end

  # Form to register with email/password.
  def new_with_password
    @form = AdminRegistrationForm.new
  end

  # Handle registration with email/password.
  def create
    form_params = params.require(:admin_registration_form)

    @form = AdminRegistrationForm.new(form_params)

    if @form.valid?
      instructor = RegisterInstructor.call(@form.instructor_params)
      login_as(instructor)
      redirect_to admin_root_path
    else
      render :new_with_password
    end

  end

end