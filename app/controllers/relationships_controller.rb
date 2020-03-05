class RelationshipsController < ApplicationController
  before_action :logged_in_user, :load_user

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private
  def load_user
    @user = if request.post?
              User.find_by id: params[:followed_id]
            else
              Relationship.find_by(id: params[:id]).followed
            end
    return if @user

    flash[:danger] = t ".invalid_user"
    redirect_to root_path
  end
end
