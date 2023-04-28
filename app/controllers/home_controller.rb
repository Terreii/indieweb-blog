class HomeController < ApplicationController
  def index
    unless request.user_agent&.include? "Mastodon"
      @entries = Entry.published.with_entryables.limit 10
    else
      @entries = []
    end
  end
end
