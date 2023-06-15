class BookmarksController < ApplicationController
  before_action :authenticate, except: %i[ index show ]
  before_action :set_bookmark, only: %i[ show edit update destroy ]
  after_action :enqueue_jobs, only: %i[ create update ]

  # GET /bookmarks or /bookmarks.json
  def index
    @bookmarks = Entry.bookmarks.published.limit 10
  end

  # GET /bookmarks/1 or /bookmarks/1.json
  def show
  end

  # GET /bookmarks/new
  def new
    @entry = Entry.new entryable: Bookmark.new
  end

  # GET /bookmarks/1/edit
  def edit
  end

  # POST /bookmarks or /bookmarks.json
  def create
    @entry = Entry.new(bookmark_params.merge entryable_type: Bookmark.name, published: true)

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry.bookmark, notice: "Bookmark was successfully created." }
        format.json { render :show, status: :created, location: @entry.bookmark }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookmarks/1 or /bookmarks/1.json
  def update
    respond_to do |format|
      if @entry.update(bookmark_params)
        format.html { redirect_to @entry.bookmark, notice: "Bookmark was successfully updated." }
        format.json { render :show, status: :ok, location: @entry.bookmark }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1 or /bookmarks/1.json
  def destroy
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to bookmarks_url, notice: "Bookmark was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_bookmark
      @entry = Bookmark.with_rich_text_summary_and_embeds.find(params[:id]).entry
    end

    # Only allow a list of trusted parameters through.
    def bookmark_params
      params.require(:entry).permit(Entry.permitted_attributes_with :id, :url, :summary)
    end

    def enqueue_jobs
      return if @entry.changed? # changes weren't saved
      BookmarkAuthorsJob.perform_later @entry.bookmark
      WebmentionJob.perform_later source: bookmark_url(@entry.bookmark), target: @entry.bookmark.url
    end
end
