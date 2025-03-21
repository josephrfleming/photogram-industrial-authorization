# app/policies/photo_policy.rb
class PhotoPolicy < ApplicationPolicy
  attr_reader :user, :photo

  def initialize(user, photo)
    super
    @user  = user   # current_user
    @photo = photo
  end

  # Example: typical actions
  def index?
    # Typically allow all, or only signed-in users, or your own logic
    true
  end

  def show?
    # e.g. Only allow if photo is not private, or user is owner/follower
    photo.owner == user || !photo.owner.private? || photo.owner.followers.include?(user)
  end

  def create?
    # e.g. must be signed in
    !user.nil?
  end

  def update?
    photo.owner == user
  end

  def destroy?
    photo.owner == user
  end
end
