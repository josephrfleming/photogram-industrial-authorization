# app/policies/user_policy.rb
class UserPolicy < ApplicationPolicy
  # user   => current_user
  # record => @user (the user being viewed or acted upon)

  # Optional scope if you want to filter which users appear in UsersController#index
  class Scope < Scope
    def resolve
      # For example:
      # 1. Everyone can see all users (public):
      #    scope.all
      # 2. Or only signed-in users can see all, else none:
      #    user ? scope.all : scope.none
      scope.all
    end
  end

  # index? is used if you do `authorize @users` or `policy_scope(User)` in index
  def index?
    true
  end

  # Viewing a user’s profile
  def show?
    # Example: show if public, or if user == record, or user is admin, etc.
    true
  end

  # Viewing what the user "liked"
  def liked?
    # Example: allow if the profile is public or the same user or an admin
    true
  end

  # Viewing the "feed" (your old must_be_owner_to_view logic)
  def feed?
    user == record || user&.admin?
  end

  # Viewing the "discover" page
  def discover?
    user == record || user&.admin?
  end
end
