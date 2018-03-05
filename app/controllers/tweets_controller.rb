class TweetsController < ApplicationController

# before_action :move_to_index, except: :index
#move_to_indexをnewアクションとcreateアクションの前でのみ動かすように設定している
  def index
    @tweets = Tweet.includes(:user).page(params[:page]).per(5).order("id DESC")
    #orderメソッドはallメソッドを省略ことができるので @tweets = Tweet.order("id DESC")としても良い
    #またorderメソッドの引数は("create_at DESC")でも良い
    #pageメソッドとperメソッドはページネーションのgemファイルであるkaminariをインストールするとついてくる
    #pageメソッド→このメソッドは、ページネーションにおけるページ数を指定します。
#ビューのリクエストの際paramsの中にpageというキーが追加されて、その値がビューで指定したページ番号となります。なので、pageの引数はparams[:page]となります。
#なぜincludesメソッドを使用するのか→includesメソッドを使用しないとindexアクションで全ツイートを取得するのに加え、それにひもづくuserの情報も全て呼び出され大量のSQLが発行されることにより処理が重くなってしまうから
#元々はこれ→ @tweets = Tweet.all.order("id DESC").page(params[:page]).per (5)
#includesメソッドとは n+1問題を解決できる 指定された関連モデルをまとめて取得することでSQLの発行回数が１回?!で済ますことができるもの
#なぜuserテーブルのテーブルの情報が必要なのか？→index.htnl.erbでnicknameなどuserテーブルの情報も@tweetsに代入されている前提で@tweetsは使用されるから
#@tweets = Tweet.includes(:users).page(params[:page]).per(5).order("id DESC")することでエラー地獄にはまった
#includes(:users)ではなくincludes(:user)にすること なぜならincludesメソッドはモデル名を引数に取りここでのモデル名はモデルクラスのファイル名の.rbを無くした版だから
#モデル名は単数形かつ全部小文字 主に「rails g devise モデル名」と「モデル名.rb」でしか使わない
  end

  def  new
  end

  def  create

       Tweet.create(image: tweet_params[:image], text: tweet_params[:text], user_id: current_user.id)
#元々はTweet.create(tweet_params)と書いていたがuser_idカラムに追加でログイン中のユーザーのidを保存しないといけないので...
# Tweet.create(name: tweet_params[:name], image: tweet_params[:image], text: tweet_params[:text])に変更した
#current_userとは？→deviseについてくるヘルパーメソッド 現在ログイン中のユーザーのレコードを、userクラスのインスタンスとして取得することができるメソッド つまりidカラムの値が１のアカウントでログインしているときcurrent_userはUser.find(1)と同じ意味を持つ
# def  create
#Tweet.create(name: params[:name], image: params[:image], text: params[:text])
#end      について
#paramsにはキーと一緒にフォームがバリューという形でコントローラに送られてくる  それをparamsメソッドでキーを引数にすることでバリューを取得する
#createメソッドについて→引数は(カラム名:保存する値)

    end

 def destroy
     tweet = Tweet.find(params[:id])
     #変数tweetにTweetモデルクラス(tweetsテーブル)にfindメソッドを使用してキーがidのバリューを取得する
     #ここで取得するidのバリューはtweetsテーブルのすべてのバリューではない
     #ルーティングで:idとすることで勝手にログインしているユーザーのidがparamsの中に追加されてコントローラに送られてくるのでそれをparamsメソッドを使って取得することができる
      if tweet.user_id == current_user.id
        #もしtweetという変数にuser_idメソッドを使用して取得した値が現在ログイン中のユーザーのレコードをuserクラスのインスタウンスとして取得してそのインスタンスにidメソッドを実行し、現在ログイン中のユーザーのidと同じであったならば
        tweet.destroy
        #tweet変数にactiverecordクラスで定義されたdestroyアクションを実行する
      end
      #↑後置ifを使用して tweet.destroy if tweet.user_id == current_user.idと簡潔に書くこともできる
    end

def edit
   @tweet = Tweet.find(params[:id])
 end

def update
      tweet = Tweet.find(params[:id])
      if tweet.user_id == current_user.id
        tweet.update(tweet_params)
        #updateメソッドはActiceRecordクラスで定義されているメソッド
        #updateメソッドの使い方→オブジェクト名.update.(更新したいカラム名: 更新する値)
        #「ビュー側で決定するパラメーターのキーの名前」を、「更新するテーブルのカラム名」と一致させておくことで、tweet_paramsとしてまとめるだけでupdateメソッドの引数にすることができるらしい
        #ここではedit.html.erbで@tweet.imageや@tweet.textのように更新するテーブルのカラム名と一致させている
      end
    end

  def show
    @tweet = Tweet.find(params[:id])
     @comments = @tweet.comments.includes(:user)
     #ツイートの詳細画面でツイートと結びつくコメントを表示するためにコメントのレコードをあらかじめ変数に入れておく必要がある
     #ツイート一つに対し多くのコメントとそのコメントをしたuserがいるので@tweet.comments.includes(:user)となる
     #なぜincludes(:userS)ではないのか→
     #なぜ変数の名前が@commentsなのか→複数のコメントのレコードが入っているため
     #@commentsには「複数のコメントのレコードが入っているので配列の形になっている」つまり複数のデータが一つの変数に入るときは配列の形になる
  end

#なぜprivateメソッド以降にメソッドを定義しないのか？
#→privateメソッド以降に定義したメソッドはクラスの外部から呼び出せなくなるから
    private
    def tweet_params
      params.permit( :image, :text)
    end

    def move_to_index
      redirect_to action: :index unless user_signed_in?

      #unless文とは？→user_signed_in?でfalseが帰ってきた場合手前の式を実行する文
    end

end
