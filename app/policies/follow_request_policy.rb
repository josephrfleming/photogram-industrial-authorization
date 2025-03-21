# app/policies/follow_request_policy.rb
class FollowRequestPolicy < ApplicationPolicy
  # user => current_user
  # record => the FollowRequest object

  # If you are using policy_scope(FollowRequest) in the index, define a Scope:
  class Scope < Scope
    def resolve
      # Example: only show follow requests where user is the recipient
      scope.where(recipient: user)
      # or if an admin can see all, you might do:
      #   user.admin? ? scope.all : scope.where(recipient: user)
    end
  end

  # Show a follow request
  def show?
    record.sender == user || record.recipient == user || user&.admin?
  end

  # Usually you'd allow new if user is logged in
  def new?
    user.present?
  end

  # Create a follow request
  def create?
    user.present?
  end

  # Edit a follow request (canceling, etc.)
  # - Possibly only the sender can edit (like your old code).
  def edit?
    record.sender == user || user&.admin?
  end

  # Update a follow request:
  # - Typically only the recipient can accept/reject
  def update?
    record.recipient == user || user&.admin?
  end

  # Destroy a follow request:
  # - Possibly the sender or the recipient
  def destroy?
    record.sender == user || record.recipient == user || user&.admin?
  end
end
