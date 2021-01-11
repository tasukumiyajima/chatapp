class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    # room.jsのrecievedメソッドにmessageをbroadcast(送信)する
    # partial: 'messages/message'の内容をmessageとしてbroadcastする
    ActionCable.server.broadcast "room_channel_#{message.room_id}", message: render_message(message)
  end

  private

  def render_message(message)
    # ApplicationController.rendererでは、コントローラーのアクションの制約を受けずに、任意のビューファイルをレンダリング可能
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
