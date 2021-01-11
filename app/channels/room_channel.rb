class RoomChannel < ApplicationCable::Channel
  # クライアントがサーバーに接続すると同時に実行される
  def subscribed
    # room_channel.rbとroom.jsの間でデータの送受信を可能にする
    stream_from "room_channel_#{params['room']}"
  end

  # クライアントがサーバーとの接続を解除したときに実行される
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # room.jsで実行されたspeakのmessageを受けとり、Messageをデータベースに保存
  def speak(data)
    Message.create!(content: data['message'], user_id: current_user.id, room_id: params['room'])
  end
end
