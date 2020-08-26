class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  after_action :set_csrf_cookie

  protected

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

    def verified_request?
      super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
    end

    def set_csrf_cookie
      cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
    end

end