class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find_by(name: params[:name])
  end

  def create
    @tag = Tag.find_or_initialize_by name: tags_params

    respond_to do |format|
      if @tag.save
        format.turbo_stream
        format.html { redirect_to @tag, notice: "Tag was successfully created." }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html {}
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def tags_params
      params.require(:tag)[:name].strip.downcase
    end
end
