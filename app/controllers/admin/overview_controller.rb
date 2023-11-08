class Admin::OverviewController < ApplicationController
  before_action :authenticate

  def index
    @entries = Entry.with_entryables.order published_at: "DESC"
  end
end
