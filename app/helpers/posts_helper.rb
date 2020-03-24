module PostsHelper
  def display_description description
    html = ""
    description.split("\n").each do |line|
      line.to_s.split(" ").each do |word|
        html << if word.start_with? "#"
                  link_to(word, searches_path(search: word), class: "hashtag")
                else
                  word + " "
                end
      end
      html << "<br>"
    end
    html.html_safe
  end

  def like_unlike object
    if user_signed_in? && object.likers?(current_user)
      "likes/unlike"
    else
      "likes/like"
    end
  end

  def bookmark_unbookmark post
    if user_signed_in? && current_user.bookmarking?(post)
      "bookmarks/unbookmark"
    else
      "bookmarks/bookmark"
    end
  end

  def count_like object
    User.likers_to_likeable(object.id, object.class.name).size
  end
end
