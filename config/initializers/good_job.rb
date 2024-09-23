# Config for GoodJob
# https://github.com/bensheldon/good_job
Rails.application.configure do
  config.good_job.execution_mode = :async
  config.good_job.retry_on_unhandled_error = true
  config.good_job.queues = '*'
  config.good_job.max_threads = 2 # Change if I need more
end
