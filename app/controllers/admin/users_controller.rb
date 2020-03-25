class Admin::UsersController < ApplicationController
  before_action :logged_in_user, :is_admin
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.page(params[:page])
                 .per Settings.user.previews_per_page
    @title = t ".users"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".signup_success"
      redirect_to root_path
    else
      flash.now[:danger] = t ".signup_failed"
      render :new
    end
  end

  def show
    render "users/show"
  end

  def edit; end

  def update
    params[:user][:gender] = params[:user][:gender].to_i
    params[:user][:status] = params[:user][:status].to_i
    if @user.update_user user_params_update
      flash[:success] = t ".update_succeed"
      redirect_to @user
    else
      flash.now[:danger] = t ".update_failed"
      render "users/edit"
    end
  end

  def destroy
    if @user.destroy
      respond_to :js
    else
      @messages = t ".error_destroy"
      respond_to do |format|
        format.html{redirect_to root_path}
        format.js{flash.now[:notice] = @messages}
      end
    end
  end
end
