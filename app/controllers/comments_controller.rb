class CommentsController < ApplicationController
  before_action :logged_in_user, :load_post, only: :create

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

  private
  def load_post
    @post = Post.find_by id: params[:post_id]
    return if @post

    flash[:danger] = t ".post_not_found"
    redirect_back fallback_location: root_path
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
