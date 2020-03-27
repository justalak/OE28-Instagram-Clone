class FacebookLoginController < ApplicationController
  before_action :user_exist, :email_exist
  def create
    facebook_info = request.env["omniauth.auth"].info
    @user = User.new name: facebook_info.name,
      email: facebook_info.email,
      uid: request.env["omniauth.auth"].uid
    render "users/new"
  end

  private

  def user_exist
    user = User.find_by uid: request.env["omniauth.auth"].uid
    return unless user

    log_in user
    redirect_to root_path
  end

  def email_exist
    user = User.find_by email: request.env["omniauth.auth"].info.email
    return unless user

    flash[:danger] = t ".email_taken"
    redirect_to login_path
  end
end
