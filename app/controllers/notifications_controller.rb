class NotificationsController < ApplicationController
  before_action :logged_in_user, :load_notification, only: %i(update destroy)

  def index
    @notifications = current_user.passive_notifications
                                 .send(params[:type])
                                 .order_by_created_at
                                 .page(params[:page])
                                 .per Settings.user.previews_per_page
    @page = params[:page]
    respond_to do |format|
      format.html{redirect_to current_user}
      format.js
    end
  end

  def update
    @messages = t ".error_update" unless @notif.read!
    @type_action = Settings.notification.update
    respond_to do |format|
      format.html{redirect_to current_user}
      format.js
    end
  end

  def destroy
    @messages = t ".error_destroy" unless @notif.destroy
    @type_action = Settings.notification.delete
    respond_to do |format|
      format.html{redirect_to current_user}
      format.js{render "notifications/update"}
    end
  end

  private

  def load_notification
    @notif = Notification.find_by id: params[:id]
    return if @notif

    @messages = t ".error_update"
    respond_to do |format|
      format.html{redirect_to current_user}
      format.js{render "notifications/update"}
    end
  end

  def notification_params
    params.require(:notification).permit :status
  end
end
