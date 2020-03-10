module PostsHelper
  def separate_lines description
    description.split "\n"
  end

  def separate_words line
    line.to_s.split " "
  end

  def like_unlike post
    return "likes/unlike" if post.likers? current_user

    "likes/like"
  end

  def bookmark_unbookmark post
    return "bookmarks/unbookmark" if current_user.bookmarking? post

    "bookmarks/bookmark"
  end
end
