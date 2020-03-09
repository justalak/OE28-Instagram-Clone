class StaticPagesController < ApplicationController
  before_action :log_in_user
  
  def index
    @post = Post.new
  end

  private

  def log_in_user
    return if user_signed_in?

    flash[:danger] = t "login_first"
    redirect_to login_path
  end
end
