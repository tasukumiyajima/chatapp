module EmojiSuggest
  module_function

  def self.start_with(name)
    emojis = Emoji.all.select do |emoji|
      emoji.aliases.any? do |_alias|
        _alias =~ /^#{name}/
      end
    end
    emojis.sort_by{ |e| e.name }
  end
end
