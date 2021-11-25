# メインのサンプルユーザーを1人作成する
User.create!(name:  "testman",
  email: "testman@gmail.com",
  password:              "password",
  password_confirmation: "password",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = "testman#{n+1}"
  email = "testman#{n+1}@gmail.com"
  password = "password"
  User.create!(name:  name,
      email: email,
      password:              password,
      password_confirmation: password,
      activated: true,
      activated_at: Time.zone.now)
end


# ユーザーの一部にマイクロポストを作成する
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content)}
end

# フォロー
users = User.all
user = users.first
following = users[3..45]
followers = users[2..50]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
