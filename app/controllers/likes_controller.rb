class LikesController < ApplicationController
  before_action :load_post, only: %i(index create destroy)
  before_action :logged_in_user, only: %i(create destroy)
  before_action :like_params, only: :create

  def index
    @title = t ".title"
    @tips = t ".tips"
    @users = User.likers(@post.id)
                 .page(params[:page])
                 .per Settings.user.previews_per_page
    render :like_list
  end

  def create
    params[:type_action] = params[:type_action].to_i
    like = current_user.bookmark_likes.build like_params
    if like.save
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
    like = current_user.bookmark_likes.find_by post_id: params[:id], type_action: 0
    if like.destroy
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
    @post = if request.post?
              Post.find_by id: params[:post_id]
            else
              Post.find_by id: params[:id]
            end
    return if @post

    flash[:danger] = t "likes.load_post_request.not_find_post"
    redirect_to root_path
  end

  def like_params
    params.permit :post_id, :type_action
  end
end
