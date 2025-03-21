class FollowRequestsController < ApplicationController
  before_action :set_follow_request, only: %i[ show edit update destroy ]

  # GET /follow_requests
  def index
    # Instead of manually restricting to current_user,
    # we can rely on policy_scope(FollowRequest) if we define a Scope class in FollowRequestPolicy
    @follow_requests = policy_scope(FollowRequest)
    # or if you prefer manual filtering:
    #   @follow_requests = FollowRequest.where(recipient: current_user)
    #   authorize @follow_requests  # to run an index? check on the collection
  end

  # GET /follow_requests/1
  def show
    authorize @follow_request  # calls show? in FollowRequestPolicy
  end

  # GET /follow_requests/new
  def new
    @follow_request = FollowRequest.new
    authorize @follow_request  # calls new? in FollowRequestPolicy
  end

  # GET /follow_requests/1/edit
  def edit
    authorize @follow_request  # calls edit? in FollowRequestPolicy
  end

  # POST /follow_requests
  def create
    @follow_request = FollowRequest.new(follow_request_params)
    @follow_request.sender = current_user

    authorize @follow_request  # calls create? in FollowRequestPolicy

    respond_to do |format|
      if @follow_request.save
        format.html { redirect_back fallback_location: root_url, notice: "Follow request was successfully created." }
        format.json { render :show, status: :created, location: @follow_request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @follow_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /follow_requests/1
  def update
    authorize @follow_request  # calls update? in FollowRequestPolicy

    respond_to do |format|
      if @follow_request.update(follow_request_params)
        format.html { redirect_back fallback_location: root_url, notice: "Follow request was successfully updated." }
        format.json { render :show, status: :ok, location: @follow_request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @follow_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follow_requests/1
  def destroy
    authorize @follow_request  # calls destroy? in FollowRequestPolicy

    @follow_request.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_url, notice: "Follow request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_follow_request
    @follow_request = FollowRequest.find(params[:id])
  end

  # Only allow trusted parameters.
  def follow_request_params
    params.require(:follow_request).permit(:recipient_id, :status)
    # Note: We remove :sender_id since sender is always current_user
  end
end
