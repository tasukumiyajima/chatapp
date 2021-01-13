class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }
  # messageがcreateした後にMessageBroadcastJobが実行される
  after_create_commit { MessageBroadcastJob.perform_later self }
end
