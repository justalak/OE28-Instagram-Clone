class FollowsController < ApplicationController
  before_action :load_user

  def following
    @title = t ".title"
    @users = @user.following
                  .page(params[:page])
                  .per Settings.user.previews_per_page
    render :follow_list
  end

  def followers
    @title = t ".title"
    @users = @user.followers
                  .page(params[:page])
                  .per Settings.user.previews_per_page
    render :follow_list
  end

  private
  def load_user
    @user = User.find params[:id]
    return if @user

    flash[:danger] = t "follow.find_user.not_find_user"
    redirect_to root_url
  end
end
