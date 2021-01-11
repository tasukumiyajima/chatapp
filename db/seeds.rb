users = ["yamada", "abe", "tanaka", "yave", "kitani"]
users.each_with_index do |user, i|
  User.create(
    name: "#{user}",
    email: "#{i + 1}@gamil.com",
    password: "password"
  )
end
