class SessionsController < ApplicationController
  before_action :load_user, only: :create
  def new
    redirect_to current_user if user_signed_in?
  end

  def create
    if @user&.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_to root_path
    else
      flash.now[:danger] = t ".invalid_message"
      render :new
    end
  end

  def destroy
    log_out if user_signed_in?
    redirect_to login_path
  end

  private
  def load_user
    email_username = params[:session][:email_username]
    @user = if email? email_username
              User.find_by email: email_username
            else
              User.find_by username: email_username
            end
  end
end
