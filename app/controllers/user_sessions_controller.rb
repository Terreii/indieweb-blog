class UserSessionsController < ApplicationController
  before_action :authenticate, except: %i[ new create ]
  before_action :set_user_session, only: %i[ show edit update destroy ]

  # GET /user_sessions or /user_sessions.json
  def index
    @user_sessions = UserSession.all
  end

  # GET /user_sessions/1 or /user_sessions/1.json
  def show
  end

  # GET /login or /user_sessions/new
  def new
    @default_name = request.headers['User-Agent']
  end

  # GET /user_sessions/1/edit
  def edit
  end

  # POST /user_sessions or /user_sessions.json
  def create
    if user_session = UserSession.authenticate(params[:username], params[:password], params[:name])
      session[:user_session_id] = user_session.id
      redirect_to root_path, notice: t('sessions.successful_login')
    else
      flash.now[:alert] = t('sessions.invalid_login')
      render :new
    end
  end

  # PATCH/PUT /user_sessions/1 or /user_sessions/1.json
  def update
    respond_to do |format|
      if @user_session.update(user_session_params)
        format.html { redirect_to @user_session, notice: "User session was successfully updated." }
        format.json { render :show, status: :ok, location: @user_session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_sessions/1 or /user_sessions/1.json
  def destroy
    @user_session.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: t("sessions.logout_success"), status: :see_other }
      format.json { head :no_content }
    end
  end

  # Not crud, makes destroy and set_user_session simpler
  def logout
    current_session.destroy
    reset_session
    respond_to do |format|
      format.html { redirect_to root_path, notice: t("sessions.logout_success"), status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_session
      @user_session = UserSession.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_session_params
      params.require(:user_session).permit(:name)
    end
end
