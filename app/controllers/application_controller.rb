class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting WebP, etc.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :set_user_search, if: -> { current_user.present? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  # If you want to handle Pundit authorization failures
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Optional: Enforce usage of `authorize` or `policy_scope`
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :username,
      :private,
      :name,
      :bio,
      :website,
      :avatar_image
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :username,
      :private,
      :name,
      :bio,
      :website,
      :avatar_image
    ])
  end

  private

  # For a Ransack search of users (excluding current_user)
  def set_user_search
    @q = User.where.not(id: current_user.id).ransack(params[:q])
  end

  # Handle Pundit authorization failures
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_url)
  end
end
