module Authenticatable
  extend ActiveSupport::Concern

  included do
    helper_method :current_session, :logged_in?

    def current_session
      logger.debug "current_session accessed"
      return unless cookies.encrypted[:user_session_id]
      @current_session ||= UserSession.find_and_log_current(cookies.encrypted[:user_session_id])
    end

    def authenticate
      logged_in? || access_denied
    end

    def logged_in?
      is_logged_in = current_session.present?
      logger.debug "logged_in? checked; result: #{is_logged_in}"
      is_logged_in
    end

    def access_denied
      redirect_to(login_path, notice: t('application.access_denied')) and return false
    end
  end
end
