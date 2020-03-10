class BookmarksController < ApplicationController
  before_action :load_user, :correct_user, only: %i(index correct_user)
  before_action :logged_in_user, :load_post_request, only: %i(create destroy)

  def index
    @title = t ".title"
    @tips = t ".tips"
    @posts = Post.bookmarking(@user.id).order_by_created_at
                  .page(params[:page])
                  .per Settings.user.previews_per_page
    render :bookmark_list
  end

  def create
    bookmark = current_user.bookmark_likes.build user_id: current_user.id,
      post_id: @post.id, type_action: 1
    bookmark.save
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    un = current_user.bookmark_likes.find_by post_id: @post.id, type_action: 1
    BookmarkLike.destroy un.id if un
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "bookmarks.find_user.not_find_user"
    redirect_to root_url
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "bookmarks.correct_user.not_allow"
    redirect_to root_url
  end

  def load_post_request
    @post = if request.post?
              Post.find_by id: params[:post_id]
            else
              current_user.bookmark_likes
                .find_by(id: params[:id], type_action: 1).post
            end
    return if @post

    flash[:danger] = t "bookmarks.load_post_request.invalid_user"
    redirect_to root_path
  end
end
