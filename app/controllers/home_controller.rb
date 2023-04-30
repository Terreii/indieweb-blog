class HomeController < ApplicationController
  def index
    @entries = Entry.published.with_entryables.limit 10
  end
end
