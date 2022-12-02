json.extract! user_session, :id, :name, :last_online, :created_at, :updated_at
json.current_session user_session == current_session
json.url user_session_url(user_session, format: :json)
