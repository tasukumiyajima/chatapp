FactoryBot.define do
  factory :message do
    content { "testmessage" }
    user_id { 1 }
    room_id { 1 }
  end
end
