module PostsHelper
  def display_description description
    html = ""
    description.split("\n").each do |line|
      line.to_s.split(" ").each do |word|
        if word.start_with? "#"
          html << link_to(word, "#", class: "hashtag")
        else
          htlm << word
        end
      end
      html << "<br>"
    end
    html.html_safe
  end

  def like_unlike post
    return "likes/unlike" if post.likers? current_user

    "likes/like"
  end

  def bookmark_unbookmark post
    return "bookmarks/unbookmark" if current_user.bookmarking? post

    "bookmarks/bookmark"
  end

  def count_like post
    User.likers_to_post(post.id).size
  end
end
