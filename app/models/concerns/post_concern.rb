module PostConcern
  extend ActiveSupport::Concern

  def update_post post_params
    post_params.except :images if post_params[:images].blank?
    update post_params
  end
end
