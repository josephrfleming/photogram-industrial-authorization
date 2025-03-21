# app/policies/comment_policy.rb
class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?  # or your desired logic
  end

  def update?
    record.author == user || user&.admin?
  end

  def destroy?
    record.author == user || user&.admin?
  end

  # If you rely on policy_scope for index:
  class Scope < Scope
    def resolve
      # e.g. Let admins see all, otherwise only see public or user’s own
      # scope.where(...) 
      scope.all
    end
  end
end
