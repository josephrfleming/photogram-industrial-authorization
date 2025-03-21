class LikesController < ApplicationController
  before_action :set_like, only: %i[ show edit update destroy ]

  # GET /likes
  def index
    @likes = policy_scope(Like) # Calls LikePolicy::Scope#resolve
    # Or if you prefer:
    #   @likes = Like.all
    #   authorize @likes
  end

  # GET /likes/1
  def show
    authorize @like  # Calls show? in LikePolicy
  end

  # GET /likes/new
  def new
    @like = Like.new
    authorize @like  # Calls new? (which typically defers to create?)
  end

  # GET /likes/1/edit
  def edit
    authorize @like  # Calls edit? in LikePolicy
  end

  # POST /likes
  def create
    @like = Like.new(like_params)
    authorize @like  # Calls create? in LikePolicy

    respond_to do |format|
      if @like.save
        format.html { redirect_back fallback_location: @like.photo, notice: "Like was successfully created." }
        format.json { render :show, status: :created, location: @like }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /likes/1
  def update
    authorize @like  # Calls update? in LikePolicy

    respond_to do |format|
      if @like.update(like_params)
        format.html { redirect_to @like, notice: "Like was successfully updated." }
        format.json { render :show, status: :ok, location: @like }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1
  def destroy
    authorize @like  # Calls destroy? in LikePolicy
    @like.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: @like.photo, notice: "Like was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:fan_id, :photo_id)
  end
end
