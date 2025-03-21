class UsersController < ApplicationController
  before_action :set_user, only: %i[ show liked feed discover ]

  # GET /users
  def index
    # If you want to filter which users are visible based on Pundit’s scope:
    @users = policy_scope(User)
    # If using search via @q from Ransack, do something like:
    # @users = policy_scope(User).merge(@q.result(distinct: true))

    # Alternatively, you could do:
    #   @users = @q.result(distinct: true)
    #   authorize @users
  end

  # GET /:username
  def show
    # Replace manual checks with Pundit:
    authorize @user  # calls UserPolicy#show?
  end

  # GET /:username/liked
  def liked
    authorize @user, :liked?  # calls UserPolicy#liked?
  end

  # GET /:username/feed
  def feed
    authorize @user, :feed?   # calls UserPolicy#feed?
  end

  # GET /:username/discover
  def discover
    authorize @user, :discover? # calls UserPolicy#discover?
  end

  private

    # Finds the user based on the :username parameter, or falls back to the current_user.
    def set_user
      if params[:username]
        @user = User.find_by!(username: params.fetch(:username))
      else
        @user = current_user
      end
    end
end
