class SearchesController < ApplicationController
  before_action :check_blank, :search_user, :search_post, only: :index

  def index
    return if @posts || @users

    @q = User.search_by_name_or_username @text_search
    @users = @q.result
               .page(params[:page])
               .per Settings.user.previews_per_page
  end

  private

  def check_blank
    @text_search = params[:search]
    return if @text_search.present?

    flash[:danger] = t "searches.search_blank.empty_string"
    redirect_back fallback_location: root_path
  end

  def search_post
    return unless @text_search.start_with? Settings.search.char_sharp

    @q = Post.search_by_description @text_search
    @posts = @q.result
               .page(params[:page])
               .per Settings.user.previews_per_page
  end

  def search_user
    return unless @text_search.start_with? Settings.search.char_at

    @q = User.search_by_name_or_username @text_search[1..-1]
    @users = @q.result
               .page(params[:page])
               .per Settings.user.previews_per_page
  end
end
