class User < ActiveRecord::Base
  #このUserモデルがdevise独自のdeviseコマンドrails g devise userを使用しないと作ることができない

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         has_many :tweets
         #User has many Tweetsの状態
         has_many :comments

           validates :nickname, presence: true, length: { maximum: 6 }
end
