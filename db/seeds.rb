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

# Earningデータ
CSV.foreach("db/CSV/earnings_data.csv", headers:true) do |row|
  Stock.find_by(symbol: row["symbol"]).earnings.create(
      symbol: row["symbol"],
      fiscalDateEnding: row["fiscalDateEnding"],
      reportedDate: row["reportedDate"],
      reportedEPS: row["reportedEPS"],
      estimatedEPS: row["estimatedEPS"],
      surprise: row["surprise"],
      surprisePercentage: row["surprisePercentage"],
      reportedCurrency: row["reportedCurrency"],
      totalRevenue: row["totalRevenue"],
      costOfRevenue: row["costOfRevenue"],
      operatingIncome: row["operatingIncome"],
      grossProfit: row["grossProfit"],
      operatingCashflow: row["operatingCashflow"],
      netIncome: row["netIncome"],
    )
end


  # 次回EarningEstimateデータr
  CSV.foreach("db/CSV/earnings_calendar.csv", headers:true) do |row|
    stock = Stock.find_by(symbol: row["symbol"])

    if stock
      stock.earnings.create(
        
        symbol: row["symbol"],
        fiscalDateEnding: row["fiscalDateEnding"],
        reportedDate: row["reportDate"],
        estimatedEPS: row["estimate"],
      )
    end
end


