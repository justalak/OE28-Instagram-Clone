module UserConcern
  extend ActiveSupport::Concern

  def update_user user, user_params_update
    if user_params_update[:avatar_image].blank?
      user_params_update.except :avatar_image
    end
    user.update user_params_update
  end
end
