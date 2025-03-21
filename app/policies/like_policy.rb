# app/policies/like_policy.rb
class LikePolicy < ApplicationPolicy
  # user   => current_user
  # record => @like

  class Scope < Scope
    def resolve
      # If you want all likes to be visible to all users, return scope.all
      # Otherwise, define any filtering logic
      scope.all
    end
  end

  def index?
    # e.g. any signed-in user can view likes
    user.present?
  end

  def show?
    true  # or user.present?, etc.
  end

  def new?
    create?
  end

  def create?
    user.present?
  end

  def edit?
    # e.g., only the "fan" (owner of the Like) or admin can edit
    record.fan == user || user&.admin?
  end

  def update?
    edit?
  end

  def destroy?
    # e.g., only the "fan" (owner) or admin can destroy
    record.fan == user || user&.admin?
  end
end
