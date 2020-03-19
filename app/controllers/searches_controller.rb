class SearchesController < ApplicationController
  before_action :check_blank, :search_post, :search_user, only: :index

  def index
    return if @posts || @users

    @users = User.search_by_name_username(@search)
                 .page(params[:page])
                 .per Settings.user.previews_per_page
  end

  private

  def check_blank
    @search = params[:search]
    return if @search.present?

    flash[:danger] = t "searches.search_blank.empty_string"
    redirect_to root_url
  end

  def search_post
    return unless @search.start_with? Settings.search.char_sharp

    @posts = Post.search_by_hashtag(@search[1..-1])
                 .page(params[:page])
                 .per Settings.user.previews_per_page
  end

  def search_user
    return unless @search.start_with? Settings.search.char_at

    @users = User.search_by_name_username(@search[1..-1])
                 .page(params[:page])
                 .per Settings.user.previews_per_page
  end
end
