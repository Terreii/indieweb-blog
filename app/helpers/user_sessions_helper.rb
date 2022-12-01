module UserSessionsHelper
  # Returns the user_sessions dom_id, but if it is the current_session
  # it will be prefixed by "current_".
  def frame_id(session)
    return dom_id(session) unless session == current_session
    dom_id(session, :current)
  end
end
