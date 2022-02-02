class FeedController < ApplicationController
  def index
    @posts = Post.published.with_rich_text_body.limit 10

    respond_to do |format|
      format.any { redirect_to feed_url(format: :atom), status: :moved_permanently }
      format.atom
    end
  end
end
