# userを3人作る
users = ["user1", "user2", "user3"]
users.each_with_index do |user, i|
  User.create!(
    name: "#{user}",
    email: "#{i + 1}@gmail.com",
    password: "password"
  )
end

# roomを5つつくる
3.times do |n|
  Room.create!(name: "room#{n + 1}")
end

# それぞれのroomで各userが10つmessageを投稿する
users = User.all
rooms = Room.all
10.times do |n|
  content = Faker::Games::Pokemon.name
  users.each do |user|
    rooms.each do |room|
      user.messages.create!(content: content, room_id: room.id)
    end
  end
end

# room1のmessageのみ3人のuserが既読する
users = User.all
room = Room.first
users.each do |user|
  last_message_room1 = room.messages.where.not(user_id: user.id).order(:id).last
  user.checks.create!(message_id: last_message_room1.id)
end
