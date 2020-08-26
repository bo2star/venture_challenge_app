module Student::Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_student
  end

  protected

    def current_student
      @current_student ||= find_current_student
    end

    def require_student
      if !current_student
        session[:return_to_url] = request.url if request.get?
        flash.alert = 'Please log in'
        flash.keep
        redirect_to login_path
      end
    end

  private

    def login_as(student)
      session[:student_id] = student.id
    end

    def logout
      session[:student_id] = nil
    end

    # used when a user tries to access a page while logged out, is asked to login,
    # and we want to return him back to the page he originally wanted.
    def redirect_back_or_to(url, flash_hash = {})
      redirect_to(session[:return_to_url] || url, flash: flash_hash)
      session[:return_to_url] = nil
    end

    def find_current_student
      Student.find_by(id: session[:student_id])
    end

end