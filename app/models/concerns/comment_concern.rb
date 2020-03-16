module CommentConcern
  def root?
    parent_id.nil?
  end  
end
