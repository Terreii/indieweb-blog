class ApplicationController < ActionController::Base
  helper_method :current_session, :logged_in?
  before_action :activate_profiler

  def current_session
    logger.debug "current_session accessed"
    return unless session[:user_session_id]
    @current_session ||= UserSession.find_and_log_current(session[:user_session_id])
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

  def activate_profiler
    if logged_in? # This causes a set_cookie on every request!
      Rack::MiniProfiler.authorize_request
    end
  end
end
