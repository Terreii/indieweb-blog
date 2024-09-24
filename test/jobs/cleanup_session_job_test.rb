require "test_helper"

class CleanupSessionJobTest < ActiveJob::TestCase
  test "user session inactive more then 31 days should be deleted" do
    assert_difference "UserSession.count", -1 do
      CleanupSessionJob.perform_now
    end
  end
end
