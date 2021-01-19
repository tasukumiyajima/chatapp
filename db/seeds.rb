users = ["user1", "user2", "user3", "user4", "user5"]
users.each_with_index do |user, i|
  User.create(
    name: "#{user}",
    email: "#{i + 1}@gmail.com",
    password: "password"
  )
end

Room.create(name: "first_room")
