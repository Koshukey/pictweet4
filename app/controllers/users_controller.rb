class UsersController < ApplicationController
   def show
user = User.find(params[:id])
#コメント欄に表示されるユーザーをクリックすることで送られてきたidをparamsメソッドで取得している
      @nickname = user.nickname
     # なぜ元々は @nickname = current_user.nicknameだったのに変更したのか
#このように変更しないとコメントしたuserをクリックした時に現在ログインしている自分のページにしか飛ばなくなってしまうから
@tweets = user.tweets.page(params[:page]).per(5).order("created_at DESC")
#最初 @tweets = current_user.tweets.per(5).order("created_at DESC")描いててperメソッドはundefinedってエラーが出た
#perメソッドはpageメソッドと一緒に使う
      #whereメソッドとは？→ActiveRecordメソッドの一つ
      #モデル.where(カラム名: そのカラムの値)のように引数部分に条件を指定することで、テーブル内の条件に一致したレコードのインスタンスを配列型で取得できる
      #@tweetsについて  元々は@tweets = Tweet.where(user_id: current_user.id).page(params[:page]).per(5).order("created_at DESC")
#アソシエーションを利用できるようになったが故にcurrent_user.tweets.per(5)のように省略できた
#なぜcurrent_user.tweetではなくてcurrent_user.tweetsなのか→current_user.tweetsと続ければ、現在ログインしているユーザーの投稿したツイート全てを取得することができるから
# つまりUser has many tweetsの関係に乗っかっているから
    end
end
