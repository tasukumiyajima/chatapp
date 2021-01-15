users = ["yamada", "abe", "tanaka", "yave", "kitani"]
users.each_with_index do |user, i|
  User.create(
    name: "#{user}",
    email: "#{i + 1}@gmail.com",
    password: "password"
  )
end

Room.create(name: "first_room")

# 10.times do |n|
#   Message.create(
#     content: "test content",
#     user_id: "1",
#     room_id: "1"
#   )
# end
