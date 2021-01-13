class Room < ApplicationRecord
  has_many :room_users
  has_many :users, through: :room_users
  has_many :messages

  def users_in_room
    User.joins(:messages).where(messages: { room_id: id }).distinct
  end
end
