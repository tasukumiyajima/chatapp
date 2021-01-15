class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    # room.jsのrecievedメソッドにmessageをbroadcast(送信)する
    # partial: 'messages/message'の内容をmessageとしてbroadcastする
    ActionCable.server.broadcast "room_channel",
                                 message: render_message(message),
                                 room_id: message['room_id']
  end

  private

  def render_message(message)
    # ApplicationController.rendererでは、コントローラーのアクションの制約を受けずに、任意のビューファイルをレンダリング可能
    ApplicationController.render_with_signed_in_user(
      message.user,
      partial: 'messages/message',
      locals: { message: message }
    )
  end
end
