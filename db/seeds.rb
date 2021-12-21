# メインのサンプルユーザーを1人作成する
User.create!(name:  "testman",
  email: "testman@gmail.com",
  password:              "Password1",
  password_confirmation: "Password1",
  admin: false,
  activated: true,
  activated_at: Time.zone.now)



  User.create!(name:  "administer",
    email: "admin@gmail.com",
    password:              ENV["admin_pass"],
    password_confirmation: ENV["admin_pass"],
    admin: true,
    activated: true,
    activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = "testman#{n}"
  email = "testman#{n}@gmail.com"
  password = "Password1"
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



# Symbolデータ
CSV.foreach("db/CSV/nasdaq_screener.csv", headers:true) do |row|
  Stock.create(
    symbol: row["symbol"],
    name: row["name"],
    country: row["country"],
    ipoYear: row["ipoYear"],
    sector: row["sector"],
    industry: row["industry"]
  )

end


symbols = ["TSLA", "AAPL", "GOOG", "AMZN", "FB", "NVDA", "AMD", "ABNB","DAL","CCL","AR","FANG","MSFT"]

symbols.each do |symbol|
  stock = Stock.find_by(symbol: symbol)
  stock.add_follower(user)
end