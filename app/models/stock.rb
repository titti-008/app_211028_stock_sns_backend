class Stock < ApplicationRecord
  has_many :earnings, dependent: :destroy
  has_many :financial_data, dependent: :destroy
  validates :symbol, presence:true, uniqueness: true
  before_save :upcase_symbol

  has_many :stock_relationships, dependent: :destroy
  has_many :users, through: :stock_relationships


  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      stock = find_by(symbol: row["Symbol"]) || new
      # CSVからデータを取得し設定する
      stock.attributes = row.to_hash.slice(*updatable_attributes)
      stock.save

    end
  end


  #すでにフォローしているuserならtrue
  def is_following_by_user?(user)
    self.users.include?(user)
  end

    # stockのフォロー
    def add_follower(user)
      self.users << user
    end
  
    def delete_follower(user)
      self.stock_relationships.find_by(user_id: user.id).destroy
    end



  private ############################


  def upcase_symbol
    self.symbol.upcase!
  end


  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["symbol","name","country","ipoYear","sector","industry"]
  end


end
