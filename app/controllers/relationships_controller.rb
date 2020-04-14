class RelationshipsController < ApplicationController
  before_action :authenticate_user!, :load_user
  before_action :load_relationship, only: %i(update destroy)
  authorize_resource
  skip_authorize_resource only: :create

  def create
    params[:status] = params[:status].to_i
    @relationship = current_user.active_relationships
                                .build relationship_params
    if @relationship.save
      push_create_notification
    else
      @messages = t ".create_failed"
    end
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def update
    @messages = t ".error_update" unless @relationship.accept!
    @update = {
      notifications: find_notifications_by_relationship(@relationship),
      message_confirmed: t("notifications.active_relationship.confirmed")
    }

    push_update_notification

    respond_to do |format|
      format.html{redirect_to current_user}
      format.js
    end
  end

  def destroy
    @messages = t ".error_destroy" unless @relationship.destroy
    @notifications = find_notifications_by_relationship @relationship
    respond_to do |format|
      @message_refused = t "notifications.active_relationship.refused"
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_user
    @user = if request.post?
              User.find_by id: relationship_params[:followed_id]
            else
              Relationship.find_by(id: params[:id]).followed
            end
    return if @user

    flash[:danger] = t ".invalid_user"
    redirect_to root_path
  end

  def load_relationship
    @relationship = Relationship.find_by(id: params[:id])
    return if @relationship

    respond_to do |format|
      format.html{redirect_to current_user}
      format.js
    end
  end

  def relationship_params
    params.permit :followed_id, :status
  end

  def push_create_notification
    return if current_user? @user

    notif_hash = {
      sender_id: current_user.id,
      receiver_id: @user.id,
      post_id: nil,
      type_notif: @user.public_mode? ? Settings.notification.follow : Settings.notification.request
    }
    PushWorker.perform_async notif_hash
  end

  def push_update_notification
    return unless current_user? @relationship.followed

    notif_hash = {
      sender_id: @relationship.followed.id,
      receiver_id: @relationship.follower.id,
      post_id: nil,
      type_notif: Settings.notification.accept
    }
    PushWorker.perform_async notif_hash
  end
end
