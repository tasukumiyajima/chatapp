class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :checks, dependent: :destroy
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }
  # messageがcreateした後にMessageBroadcastJobが実行される
  after_create_commit { MessageBroadcastJob.perform_later self }

  # メッセージを既読済みのユーザー
  def checked_users
    User.joins(:checks).where(checks: { message_id: id })
  end

  # 検索ワード(search)をcontentに含むmessageを探す
  def self.search(search, room_id)
    if search.present? && room_id.present?
      Message.where(['content LIKE ?', "%#{search}%"]).where(room_id: room_id)
    elsif search.present?
      Message.where(['content LIKE ?', "%#{search}%"])
    end
  end
end
