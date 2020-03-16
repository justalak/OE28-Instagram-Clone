class CommentsController < ApplicationController
  before_action :logged_in_user, :load_post
  before_action :load_comment, :correct_user, except: :create

  def create
    @comment = @post.comments.build comment_params
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.html{redirect_to @post}
        format.js
      end
    else
      flash[:danger] = t ".post_comment_fail"
      redirect_back fallback_location: root_path
    end
  end

  def edit; end

  def update
    if @comment.update comment_params
      flash[:success] = t ".update_success"
      redirect_to @post
    else
      flash.now[:danger] = t ".update_fail"
      render :edit
    end
  end

  def destroy
    if @comment.destroy
      flash[:success] = t ".destroy_success"
    else
      flash[:danger] = t ".destroy_failed"
    end
    redirect_back fallback_location: root_path
  end

  private

  def load_post
    @post = Post.find_by id: params[:post_id]
    return if @post

    flash[:danger] = t ".post_not_found"
    redirect_back fallback_location: root_path
  end

  def load_comment
    @comment = @post.comments.find_by id: params[:id]
    return if @comment

    flash[:danger] = t ".comment_not_found"
    redirect_back fallback_location: root_path
  end

  def correct_user
    return if current_user? @comment.user

    flash[:danger] = t "access_denied"
    redirect_back fallback_location: root_path
  end

  def comment_params
    params.require(:comment).permit :content, :parent_id
  end
end
