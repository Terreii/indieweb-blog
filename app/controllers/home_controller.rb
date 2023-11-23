class HomeController < ApplicationController
  def index
    @entries = Entry.published.with_entryables.limit 10
    default_cache @entries
  end
end
