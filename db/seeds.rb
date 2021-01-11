users = ["yamada", "abe", "tanaka", "yave", "kitani"]
users.each_with_index do |user, i|
  User.create(
    name: "#{user}",
    email: "#{i + 1}@gamil.com",
    password: "password"
  )
end

Room.create

10.times do |n|
  Message.create(
    content: "test content",
    user_id: "1",
    room_id: "1"
  )
end
