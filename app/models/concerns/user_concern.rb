module UserConcern
  extend ActiveSupport::Concern

  def update_user user_params_update
    if user_params_update[:avatar_image].blank?
      user_params_update.except :avatar_image
    end
    update user_params_update
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  def bookmarking? post
    Post.bookmarking(id).include? post
  end
end
