class LikesController < ApplicationController
  before_action :logged_in_user, :load_post, only: :index
  before_action :post_exists, only: %i(create destroy)
  before_action :find_like, only: :destroy

  def index
    @title = t ".title"
    @tips = t ".tips"
    @likers = User.likers_to_post(@post.id)
                  .page(params[:page])
                  .per Settings.user.previews_per_page
  end

  def create
    params[:type_action] = params[:type_action].to_i
    @new_like = current_user.bookmark_likes.build bookmark_like_params
    if @new_like.save
      notif = {
        sender: current_user,
        receiver: @post.user,
        post: @post,
        type_notif: Settings.notification.like
      }
      NotificationPushService.new(notif).push_notification unless current_user? @post.user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t "likes.find_post.not_find_post"
      redirect_to root_url
    end
  end

  def destroy
    if @like.destroy
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t "likes.find_post.not_find_post"
      redirect_to root_url
    end
  end

  private

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:danger] = t "likes.find_post.not_find_post"
    redirect_to root_url
  end

  def find_like
    @like = current_user
            .bookmark_likes
            .find_by post_id: bookmark_like_params[:post_id],
              type_action: bookmark_like_params[:type_action]
    return if @like

    flash[:danger] = t "likes.find_post.not_find_post"
    redirect_to root_url
  end
end
