class Api::EmojisController < ApplicationController
  EMOJI_NUM_LIMIT = 10
  def index
    @emojis = EmojiSuggest.start_with(params[:query]).first(EMOJI_NUM_LIMIT)
  end
end
