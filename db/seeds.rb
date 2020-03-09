User.create!(email: "viethoang2901hust@gmail.com",
  username: "viethoangle",
  name: "Lê Việt Hoàng",
  password: "123456",
  password_confirmation: "123456",
)

User.create!(email: "viethoang29012hust@gmail.com",
  username: "viethoanglee",
  name: "Lê Việt Hoàng",
  password: "123456",
  password_confirmation: "123456",
)

28.times do |n|
  email = "viethoang29012hust-index#{n}@gmail.com"
  username = "viethoang#{n}"
  name = Faker::Name.name
  password = "123456"
  password_confirmation = "123456"
  User.create(
    email: email,
    username: username,
    name: name,
    password: password,
    password_confirmation: password_confirmation
  )
end

users = User.all
user = users.first
following = users[2..20]
followers = users[18..30]
following.each { |other_user| user.follow other_user }
followers.each { |other_user| other_user.follow user }
