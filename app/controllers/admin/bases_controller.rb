class Admin::BasesController < ApplicationController
  before_action :authenticate_user!, :is_admin?

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.load_user.not_find_user"
    redirect_to root_path
  end

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:danger] = t "post_not_found"
    redirect_to root_path
  end

  def is_admin?
    return if current_user.admin?

    flash[:danger] = t "not_admin"
    redirect_to root_path
  end
end
