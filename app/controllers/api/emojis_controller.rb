class Api::EmojisController < ApplicationController
  def index
    @emojis = EmojiSuggest.start_with(params[:query]).first(Constants::EMOJI_MAX_COUNT)
  end
end
