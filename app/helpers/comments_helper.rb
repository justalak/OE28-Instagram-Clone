module CommentsHelper
  def display_comment content
    html = ""
    content.to_s.split(" ").each do |word|
      html << if word.start_with? "@"
                username = word[1..-1]
                link_to word, searches_path(username: username),
                        class: "hashtag" + " "
              else
                word
              end
      html << " "
    end
    html.html_safe
  end
end
