class RelationshipsController < ApplicationController
  before_action :logged_in_user, :load_user

  def create
    current_user.follow @user
    notif = {
      sender: current_user,
      receiver: @user,
      post: nil,
      type_notif: Settings.notification.follow
    }
    NotificationPushService.new(notif).push_notification unless current_user? @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private
  def load_user
    @user = if request.post?
              User.find_by id: params[:followed_id]
            else
              Relationship.find_by(id: params[:id]).followed
            end
    return if @user

    flash[:danger] = t ".invalid_user"
    redirect_to root_path
  end
end
