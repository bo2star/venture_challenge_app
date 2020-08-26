class Admin::SessionsController < AdminController

  def new
  end

  def new_with_password
  end

  # Handle login with email/password.
  def create
    instructor = Instructor.find_by(email: params[:email])

    if instructor
      if instructor.authenticate(params[:password]) && instructor.linked_in?
        login_as(instructor)
        redirect_to admin_root_path
        return
      elsif instructor.linked_in?
        redirect_to admin_login_path, notice: 'Please log in with LinkedIn'
        return
      else instructor.authenticate(params[:password])
        login_as(instructor)
        redirect_to admin_root_path
        return
      end
    end

    flash.now.alert = 'Email or password is invalid'
    render :new_with_password
  end

  def destroy
    logout
    redirect_to '/'
  end

end
