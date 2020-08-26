module Admin
module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_admin
  end

  protected

    def current_admin
      @current_admin ||= find_current_admin
    end

    def require_admin
      if !current_admin
        session[:return_to_url] = request.url if request.get?
        flash.keep
        redirect_to admin_login_url
      end
    end

  private

    def login_as(admin)
      session[:admin_id] = admin.id
    end

    def logout
      session[:admin_id] = nil
    end

    # used when a user tries to access a page while logged out, is asked to login,
    # and we want to return him back to the page he originally wanted.
    def redirect_back_or_to(url, flash_hash = {})
      redirect_to(session[:return_to_url] || url, flash: flash_hash)
      session[:return_to_url] = nil
    end

    def find_current_admin
      Instructor.find_by(id: session[:admin_id])
    end

end
end