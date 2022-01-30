class FeedController < ApplicationController
  def index
    @posts = Post.published.with_rich_text_body.limit 10

    respond_to do |format|
      format.atom
    end
  end
end
