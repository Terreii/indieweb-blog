class CleanupSessionJob < ApplicationJob
  queue_as :default

  # Deletes all outdated sessions (older then 31 days).
  def perform
    sessions = UserSession.outdated
    logger.info "CleanupSessionJob: deleting #{sessions.count} sessions."
    sessions.destroy_all
  end
end
