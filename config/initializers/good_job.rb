# Config for GoodJob
# https://github.com/bensheldon/good_job
Rails.application.configure do
  config.good_job.execution_mode = :async
  config.good_job.retry_on_unhandled_error = true
  config.good_job.queues = '*'
  config.good_job.max_threads = 2 # Change if I need more

  # Enable cron enqueuing in this process
  config.good_job.enable_cron = true

  config.good_job.cron = {
    session_cleanup: {
      cron: "0 0 * * *",
      class: "CleanupSessionJob",
      description: "Delete all UserSessions, which are inactive longer then 31 days.",
      enabled_by_default: -> { Rails.env.production? } # Only enable in production
    }
  }
end

ActiveSupport.on_load(:good_job_application_controller) do
  include Authenticatable

  before_action do
    raise ActionController::RoutingError.new('Not Found') unless logged_in?
  end
end
