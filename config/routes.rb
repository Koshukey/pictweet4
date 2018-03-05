#resourcesメソッドで書き換えた後パート２
Rails.application.routes.draw do
devise_for :users

  root 'tweets#index'
  resources :tweets do
    resources :comments, only: [:create]
  end
  resources :users, only: [:show]

end



#resourcesメソッドで書き換えた後パート1
#Rails.application.routes.draw do
# devise_for :users
#  root 'tweets#index'
 # resources :tweets                     #tweets_controllerに対してのresourcesメソッド
 # resources :comments, only: [:create]
#  resources :users, only: [:show]       #users_controllerに対してのresourcesメソッド
#usersコントローラはshowアクションしか使わないのでonlyを使う
#end

#このままだとコメントにコメント先がないことになってしまうのでネストする
#ネストさせる前↓
#comments POST   /comments(.:format)
#ネストさせた結果↓
#tweet_comments POST   /tweets/:tweet_id/comments(.:format)








#resourcesメソッドで書き換える前

 # Rails.application.routes.draw do
  #devise_for :users
    #root  'tweets#index'
   # get 'tweets' => 'tweets#index'
   # get   'tweets/new'  =>  'tweets#new'
   # post  'tweets'      =>  'tweets#create'
   #   delete  'tweets/:id'  => 'tweets#destroy'
      #delete  'tweets/:id'と書くことで:idの部分に記述された値はコントローラ上でparams[:id]とすることで取得できます
   # patch   'tweets/:id'  => 'tweets#update'
   # get    'tweets/:id/edit'   =>  'tweets#edit'
   #  get   'users/:id'   =>  'users#show'
   #  get 'tweets/:id' => 'tweets#show'
     #こうすることでパスの一部をコントローラにパラメーターというハッシュ形式で値を送る事ができる コントローラ内でparams[:id]と記述することにすればusers/:idの:id部分の情報を使用することができる またusers controllerでbinding.pryをしてparamsと入力すると
     #=> {"controller"=>"users", "action"=>"show", "id"=>"1"}という結果が返ってきてルーティングで設定したキーとビューでパスに組み込まれたユーザーのidが追加されているのがわかる




 # end

#ルーティングを表示したときに
 #new_user_session GET    /users/sign_in(.:format)       devise/sessions#new のように.:format というものがあるがこれは
#formatオプションと呼ばれ、html形式やjson形式といった 複数の形式で出力できるというもの
