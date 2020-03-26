class Admin::UsersController < ApplicationController
  before_action :authenticate_user!, :is_admin
  before_action :load_user, except: %i(index create)

  def index
    @q = User.ransack params[:q]
    @user_hash = {
      users: @q.result.page(params[:page]).per(Settings.user.previews_per_page),
      user: User.new,
      page: params[:page]
    }
    respond_to :html, :js
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".signup_success"
    else
      flash[:danger] = t ".signup_failed"
    end
    redirect_back fallback_location: root_path
  end

  def update
    params[:user][:gender] = params[:user][:gender].to_i
    params[:user][:status] = params[:user][:status].to_i
    if @user.update_user user_params_update
      respond_to :js
    else
      @messages = t ".update_failed"
      respond_to do |format|
        format.html{redirect_back fallback_location: root_path}
        format.js{flash.now[:notice] = @messages}
      end
    end
  end

  def destroy
    if @user.destroy
      respond_to :js
    else
      @messages = t ".error_destroy"
      respond_to do |format|
        format.html{redirect_back fallback_location: root_path}
        format.js{flash.now[:notice] = @messages}
      end
    end
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".incorrect_user"
    redirect_to root_path
  end
end
