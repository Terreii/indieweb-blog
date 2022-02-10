class PostsController < ApplicationController
  before_action :authenticate, except: %i[ index show ]
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :set_all_tags, only: %i[ new edit ]

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
      add_new_tags(@post)

      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html {
          set_all_tags
          render :new, status: :unprocessable_entity
        }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/slug or /posts/slug.json
  def update
    respond_to do |format|
      if @post.update(post_params) && add_new_tags(@post)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html {
          set_all_tags
          render :edit, status: :unprocessable_entity
        }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/slug or /posts/slug.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed.", status: :see_other }
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
      params.require(:post).permit(:title, :slug, :published_at, :body, tag_ids: [])
    end

    def set_all_tags
      @tags = Tag.all
    end

    def new_tags_params
      return '' unless params.has_key?(:new_tags)
      params[:new_tags].strip
    end

    def parse_new_tags
      new_tags_params.split(",").map {|tag| tag.strip.downcase }
    end

    def add_new_tags(post)
      tags_to_add = parse_new_tags.map do |tag|
        Tag.find_or_create_by name: tag
      end
      post.tags << tags_to_add
    end
end
