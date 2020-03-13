class BookmarksController < ApplicationController
  before_action :logged_in_user, :load_user, only: :index
  before_action :post_exists, only: %i(create destroy)
  before_action :find_bookmark, only: :destroy

  def index
    @title = t ".title"
    @tips = t ".tips"
    @posts = Post.bookmarking_by_user(@current_user.id).order_by_created_at
                 .page(params[:page])
                 .per Settings.user.previews_per_page
  end

  def create
    params[:type_action] = params[:type_action].to_i
    @new_bookmark = current_user.bookmark_likes.build bookmark_params
    if @new_bookmark.save
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t "bookmarks.find_user.not_find_user"
      redirect_to root_url
    end
  end

  def destroy
    if @bookmark.destroy
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t "bookmarks.find_user.not_find_user"
      redirect_to root_url
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "bookmarks.find_user.not_find_user"
    redirect_to root_url
  end

  def find_bookmark
    @bookmark = current_user.bookmark_likes.find_by post_id: bookmark_params[:post_id],
                                      type_action: bookmark_params[:type_action]
    return if @bookmark

    flash[:danger] = t "bookmarks.find_user.not_find_user"
    redirect_to root_url
  end

  def bookmark_params
    params.permit :post_id, :type_action
  end
end
