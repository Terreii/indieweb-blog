class HomeController < ApplicationController
  def index
    @entries = all_published_entries
  end
end
