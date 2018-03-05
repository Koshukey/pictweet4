class CommentsController < ApplicationController
  def create

 @comment = Comment.create(text: comment_params[:text], tweet_id: comment_params[:tweet_id], user_id: current_user.id)
  respond_to do |format|
    format.html { redirect_to tweet_path(params[:tweet_id])  }
    format.json
  end
   #アソシエーションtweet has many commentsに基づいて@commentと結びつくツイートのidを取得
 #@comments.tweet.idについて→@comments.tweetというオブジェクトに対しidメソッドを使用するという意味
#redirect_to "/tweets/#{@comment.tweet.id}"は非同期通信を実装した時に消した
  end
    #Commentモデルクラスにcreateメソッドを使ってインスタンスを作成


  private
  #privateメソッドを使ってcomment_paramsメソッドをコントローラ以外で呼び出せないようにしている
  def comment_params
    params.permit(:text, :tweet_id)
    #paramsという名のオブジェクトにpermitメソッドを使う
end

end
