class Room < ApplicationRecord
  has_many :room_users
  has_many :users, through: :room_users
  has_many :messages
  validates :name, presence: true, length: { maximum: 50 }

  def users_in_room
    User.joins(:messages).where(messages: { room_id: id }).distinct
  end

  # def reads_in_room(user)
  #   Read.joins(:message).where(user_id: user.id).where(message: { room_id: id })
  # end
end
