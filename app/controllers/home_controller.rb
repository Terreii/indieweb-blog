class HomeController < ApplicationController
  def index
    @entries = published_entries
  end
end
