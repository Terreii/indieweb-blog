class Admin::OverviewController < ApplicationController
  before_action :authenticate, :search_params

  # GET /admin
  def index
    @types_map = Hash[@types.map { |key| [key, true] }]
    @entries = filter_by_published(filter_by_type(Entry.with_entryables.order published_at: "DESC"))
  end

  # POST /admin/search
  def create
    args = Hash.new
    args[:published] = @published unless @published.nil?
    args[:types] = @types unless @types.empty? || @types.length == Entry.types.length
    redirect_to admin_path(args), status: :see_other
  end

  private

    def search_params
      published = params[:published]
      @published = published if %w[draft published].include?(published)
      @types = params.fetch(:types, []).filter { |type| Entry.types.include? type }
    end

    def filter_by_type(entries)
      if @types.empty? || @types.length == Entry.types.length
        entries
      else
        entries.where(entryable_type: @types)
      end
    end

    def filter_by_published(entries)
      if @published == "draft"
        entries.draft
      elsif @published == "published"
        entries.published
      else
        entries
      end
    end
end
