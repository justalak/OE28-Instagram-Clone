module CommentConcern
  def root?
    parent_id.nil?
  end

  def mentions
    content.scan(/@(#{Settings.user.name_regex})/).flatten.map do |username|
      User.find_by(username: username)
    end.compact
  end
end
