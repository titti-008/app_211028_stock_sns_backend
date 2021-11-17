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