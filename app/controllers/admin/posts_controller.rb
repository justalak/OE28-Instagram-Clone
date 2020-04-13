class Admin::PostsController < ApplicationController
  before_action :authenticate_user!, :is_admin
  before_action :load_post, except: %i(index create)

  def index
    @q = Post.ransack params[:q]
    @post_hash = {
      post: Post.new,
      posts: @q.result.page(params[:page]).per(Settings.user.previews_per_page),
      page: params[:page]
    }
    respond_to :html, :js
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      flash[:success] = t ".upload_successfully"
    else
      flash[:danger] = t ".upload_fail"
    end
    redirect_back fallback_location: root_path
  end

  def update
    if @post.update_post post_params
      respond_to :js
    else
      @messages = t ".update_fail"
      respond_to do |format|
        format.html{redirect_back fallback_location: root_path}
        format.js{flash.now[:notice] = @messages}
      end
    end
  end

  def destroy
    if @post.destroy
      respond_to :js
    else
      @messages = t ".destroy_failed"
      respond_to do |format|
        format.html{redirect_back fallback_location: root_path}
        format.js{flash.now[:notice] = @messages}
      end
    end
  end
end
