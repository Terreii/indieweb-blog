class FeedController < ApplicationController
  skip_before_action :activate_profiler

  def index
    @entries = Entry.published.with_entryables
    @updated = @entries.empty? ? Time.new(0) : @entries.max_by{ |entry| entry.updated_at }.updated_at

    respond_to do |format|
      format.any { redirect_to feed_url(format: :atom), status: :moved_permanently }
      format.atom
    end
  end
end
