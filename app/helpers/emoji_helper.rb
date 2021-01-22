module EmojiHelper
  # viwwのcontentの中に絵文字が含まれていたときに絵文字を表示するメソッド
  def emojify(content)
    if content.present?
      h(content).to_str.gsub(/:([\w+-]+):/) do |match|
        if emoji = Emoji.find_by_alias(Regexp.last_match(1))
          %(<img alt="#{Regexp.last_match(1)}" src="#{image_path("emoji/#{emoji.image_filename}")}"
            style="vertical-align:middle" width="20" height="20" />)
        else
          match
        end
      end.html_safe
    end
  end
end
