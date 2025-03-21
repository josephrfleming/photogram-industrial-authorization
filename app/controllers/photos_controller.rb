class PhotosController < ApplicationController
  before_action :set_photo, only: %i[ show edit update destroy ]

  # GET /photos
  def index
    # Use Pundit’s policy_scope to retrieve only the photos the user is allowed to see
    @photos = policy_scope(Photo)
  end

  # GET /photos/1
  def show
    authorize @photo  # calls PhotoPolicy#show?
  end

  # GET /photos/new
  def new
    @photo = Photo.new
    authorize @photo  # calls PhotoPolicy#new?
  end

  # POST /photos
  def create
    @photo = Photo.new(photo_params)
    @photo.owner = current_user
    authorize @photo  # calls PhotoPolicy#create?

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: "Photo was successfully created." }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /photos/1/edit
  def edit
    authorize @photo  # calls PhotoPolicy#edit?
  end

  # PATCH/PUT /photos/1
  def update
    authorize @photo  # calls PhotoPolicy#update?

    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: "Photo was successfully updated." }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  def destroy
    authorize @photo  # calls PhotoPolicy#destroy?
    @photo.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_url, notice: "Photo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_params
      # owner is set automatically to current_user
      params.require(:photo).permit(:image, :comments_count, :likes_count, :caption)
    end
end
