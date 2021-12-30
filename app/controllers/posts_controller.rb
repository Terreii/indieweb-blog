class PostsController < ApplicationController
  before_action :authenticate, except: %i[ index show ]
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    if logged_in?
      @drafts = Post.draft.all
    end
    @posts = Post.published.with_rich_text_body.limit 10
  end

  # GET /posts/slug or /posts/slug.json
  def show
    unless @post.published? || logged_in?
      access_denied
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/slug/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/slug or /posts/slug.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/slug or /posts/slug.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.with_rich_text_body.find_by(slug: params[:slug])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :slug, :published_at, :body)
    end
end
