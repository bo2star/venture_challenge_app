class Student::SessionsController < StudentController

  def new
  end

  def new_with_password
  end

  # Handle login with email/password.
  def create
    student = Student.find_by(email: params[:email])

    if student
      if student.linked_in?
        redirect_to login_path, notice: 'Please log in with LinkedIn'
        return
      elsif student.authenticate(params[:password])
        login_as(student)
        redirect_to team_path
        return
      end
    end

    flash.now.alert = 'Email or password is invalid'
    render :new_with_password
  end

  def destroy
    logout
    redirect_to login_path
  end

end