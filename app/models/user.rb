class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :room_users
  has_many :messages
  has_many :rooms, through: :room_users
  has_many :checks, dependent: :destroy
  has_many :checked_messages, through: :checks, source: :message
  validates :name, presence: true, length: { maximum: 50 }

  # roomの中のuserの既読データをすべて消す
  def delete_checks_in(room)
    if checks_of_user = Check.where(user_id: id)
      checks_of_user.each do |check|
        message_of_user = Message.find(check.message_id)
        check.destroy if message_of_user.room_id == room.id
      end
    end
  end
end
