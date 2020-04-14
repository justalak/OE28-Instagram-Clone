class Ability
  include CanCan::Ability

  def initialize user
    return unless user

    if user.admin?
      can :manage, :all
    else
      can [:update], User, id: user.id
      can [:update, :destroy], [Post, Comment], user_id: user.id
      can [:update, :destroy], Relationship, followed_id: user.id
      can [:update, :destroy], Relationship, follower_id: user.id
      can [:read, :create], BookmarkLike
      can :destroy, BookmarkLike, user_id: user.id
      can [:read, :update, :destroy], Notification, receiver_id: user.id
    end
  end
end
