class StaticPagesController < ApplicationController
  after_action :default_cache

  def portfolio
  end

  def impressum
  end
end
