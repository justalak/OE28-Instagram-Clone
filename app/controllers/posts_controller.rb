class PostsController < ApplicationController
  before_action :log_in_user, only: %i(create update edit)

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

  def show; end

  private

  def post_params
    params.require(:post).permit :description
  end

  def log_in_user
    return if user_signed_in?

    flash[:danger] = t "login_first"
    redirect_to login_path
  end
end
