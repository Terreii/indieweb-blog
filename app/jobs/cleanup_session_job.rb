class CleanupSessionJob < ApplicationJob
  queue_as :default

  # Deletes all outdated sessions (older then 31 days).
  def perform
    UserSession.outdated.destroy_all
  end
end
