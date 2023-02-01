class ApplicationController < ActionController::Base
  helper_method :current_session, :logged_in?, :load_scripts?

  def current_session
    return unless session[:user_session_id]
    @current_session ||= UserSession.find_and_log_current(session[:user_session_id])
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

  # Get published entries combined and sorted by published_at.
  # Entries are posts and bookmarks. For short: all that is displayed on the root page.
  def published_entries
    entries = (published_posts + published_bookmarks).sort_by(&:published_at)
    entries.reverse
  end

  def published_posts
    Entry.posts.published.limit 10
  end

  def published_bookmarks
    Bookmark.includes(:authors).with_rich_text_summary.limit 10
  end
end
