class ApplicationController < ActionController::Base
  helper_method :current_session, :logged_in?, :load_scripts?

  def current_session
    return unless session[:user_session_id]
    @current_session ||= UserSession.find_by(id: session[:user_session_id])
  end

  def authenticate
    logged_in? || access_denied
  end

  def logged_in?
    current_session.present?
  end

  def load_scripts?
    logged_in? || !flash[:load_scripts].nil?
  end

  def access_denied
    redirect_to(login_path, notice: t('application.access_denied')) and return false
  end

  # Get all published entries combined and sorted by published_at.
  # Entries are posts and bookmarks. For short: all that is displayed on the root page.
  def all_published_entries
    posts = Post.published.with_rich_text_body.limit 10
    bookmarks = Bookmark.includes(:authors).all.limit 10
    entries = (posts + bookmarks).sort_by { |entry| entry.published_at }
    entries.reverse
  end
end
