class ApplicationController < ActionController::Base
  helper_method :current_session, :logged_in?
  before_action :activate_profiler

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

  def activate_profiler
    # only activate MiniProfiler on not if /?profile is set.
    # Because logged_in? accesses the session store. Which causes a Set-Cookie header.
    # Deactivating all caching.
    # https://stackoverflow.com/questions/42044076/why-is-rails-constantly-sending-back-a-set-cookie-header
    if params.has_key?(:profile) && logged_in?
      logger.debug "activate MiniProfiler"
      Rack::MiniProfiler.authorize_request
    end
  end
end
