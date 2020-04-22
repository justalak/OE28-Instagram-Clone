class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  load_resource :user
  load_and_authorize_resource
  before_action :correct_user, only: %i(destroy update edit)
  skip_authorize_resource only: %i(index create show)

  def index
    @posts = @user.posts.order_by_created_at
                  .page(params[:page])
                  .per Settings.user.previews_per_page
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      flash[:success] = t ".upload_successfully"
    else
      flash[:danger] = t ".upload_fail"
    end
    redirect_to root_path
  end

  def edit; end

  def destroy
    if @post.destroy
      flash[:success] = t ".destroy_success"
    else
      flash[:danger] = t ".destroy_failed"
    end

    redirect_to current_user
  end

  def update
    if @post.update_post post_params
      flash[:success] = t ".update_success"
      respond_to do |format|
        format.html{redirect_to @post}
        format.js
      end
    else
      flash.now[:danger] = t ".update_fail"
      render :edit
    end
  end

  def show
    @title = "#{@post.user_name} - #{@post.description}"
    return if display_post?(@post.user)

    flash[:danger] = t ".not_accept"
    redirect_to root_path
  end

  private

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:danger] = t "post_not_found"
    redirect_to root_path
  end

  def correct_user
    return if current_user? @post.user

    flash[:danger] = t "access_denied"
    redirect_back fallback_location: root_path
  end
end
