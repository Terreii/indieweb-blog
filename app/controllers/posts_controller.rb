class PostsController < ApplicationController
  before_action :authenticate, except: %i[ index show ]
  before_action :set_post, only: %i[ show edit update destroy ]
  after_action :webmention, only: %i[ create update ]

  # GET /posts or /posts.json
  def index
    if logged_in?
      @drafts = Entry.posts.draft.all
    end
    @posts = Entry.posts.published.limit 10
  end

  # GET /posts/slug or /posts/slug.json
  def show
    unless @entry.published? || logged_in?
      access_denied
    end
  end

  # GET /posts/new
  def new
    @entry = Entry.new entryable: Post.new
  end

  # GET /posts/slug/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @entry = Entry.build_with_post(post_params)

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry.post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @entry.post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/slug or /posts/slug.json
  def update
    respond_to do |format|
      if @entry.update(post_params)
        format.html { redirect_to @entry.post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @entry.post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/slug or /posts/slug.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @entry = Post.with_rich_text_body.find_by(slug: params[:slug]).entry
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:entry).permit(:title, :published, entryable_attributes: [:id, :slug, :summary, :thumbnail, :body, tag_ids: []])
    end

    # Notifies all links in the post about this published post.
    def webmention
      return unless @entry.published? && @entry.post.body.saved_changes?
      return if @entry.changed? # changes weren't saved
      source = post_url @entry.post

      # Stores notified URIs, so that a page is not notified twice.
      posted_uris = Set.new

      # Notify every link
      webmention_a_body source, posted_uris, @entry.post.body

      # Notify also removed links
      if @entry.post.body.body_previously_changed? && !@entry.post.body.body_previously_was.nil?
        webmention_a_body source, posted_uris, @entry.post.body.body_previously_was
      end
    end

    def webmention_a_body(source, posted_uris, body)
      parsed_body = Nokogiri.parse body.to_s
      parsed_body.css("a[href]").each do |link|
        target = URI.join source, link.attr(:href)
        target_string = target.to_s

        # I don't want to notify myself or notify a page more then 2 times
        unless target.hostname.nil? || target.hostname == request.host || posted_uris === target_string
          WebmentionJob.perform_later source:, target: target_string
          posted_uris.add target_string
        end
      end
    end
end
