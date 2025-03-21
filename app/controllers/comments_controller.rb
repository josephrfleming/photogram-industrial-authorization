class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments
  def index
    # Use Pundit's policy_scope to filter what the user is allowed to see
    @comments = policy_scope(Comment)
    # Alternatively, you could do:
    #   @comments = Comment.all
    #   authorize @comments  # if you prefer to authorize the collection directly
  end

  # GET /comments/1
  def show
    authorize @comment
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    authorize @comment
  end

  # GET /comments/1/edit
  def edit
    authorize @comment
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    authorize @comment  # Calls create? in CommentPolicy

    respond_to do |format|
      if @comment.save
        format.html { redirect_back fallback_location: root_path, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    authorize @comment  # Calls update? in CommentPolicy

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to root_url, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    authorize @comment  # Calls destroy? in CommentPolicy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_url, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    # If you rely on Pundit’s permitted attributes, you could also do:
    # params.require(:comment).permit(policy(@comment).permitted_attributes)
    # Otherwise, leave as-is:
    params.require(:comment).permit(:author_id, :photo_id, :body)
  end
end
