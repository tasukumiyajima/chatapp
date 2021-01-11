class Message < ApplicationRecord
  validates :content, presence: true
  belongs_to :user
  belongs_to :room
  # messageがcreateした後にMessageBroadcastJobが実行される
  after_create_commit { MessageBroadcastJob.perform_later self }
end
