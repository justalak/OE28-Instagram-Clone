class PostsController < ApplicationController
  before_action :log_in_user, except: :show
  before_action :load_post, except: :create
  before_action :correct_user, only: :destroy

  def create
    @post = current_user.posts.build post_params
    @post.images.attach params[:post][:images]
    if @post.save
      flash[:success] = t ".upload_successfully"
      redirect_to current_user
    else
      flash[:danger] = t ".upload_fail"
      redirect_to root_path
    end
  end

  def edit; end

  def update; end

  def destroy
    if @post.destroy
      flash[:success] = t ".destroy_success"
    else
      flash[:danger] = t ".destroy_failed"
    end
    redirect_to current_user
  end

  def show
    @title = "#{@post.user_name} - #{@post.description}"
  end

  private
  def post_params
    params.require(:post).permit :description
  end

  def log_in_user
    return if user_signed_in?

    flash[:danger] = t "login_first"
    redirect_to login_path
  end

  def correct_user
    return if current_user? @post.user

    flash[:danger] = t "login_first"
    redirect_to login_path
  end

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:danger] = t "post_not_found"
    redirect_to root_path
  end
end
