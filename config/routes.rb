# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, :controllers => {
    # コントローラーを見に行くようになる
    # 無しだと、そもそも見に行かずにデフォルトが実行される
    # (結論：deviseのコントローラーを変更したら記述が必須)
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :confirmations => 'users/confirmations'
  }

  devise_scope :user do
  #　ルーティングを指定
  #　アクションが追加されたらそのルーティングを指定する

    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy"

    #プロフィール編集画面（仮登録状態）
    get "before_sign_up", :to => "users/registrations#before_create"
    #プロフィール編集内容確認画面（仮登録状態）
    post "before_sign_up_confirm", :to => "users/registrations#before_confirm"
    #プロフィール編集内容のアップデート処理（仮登録→本登録に）
    post "before_sign_up", :to => "users/registrations#before_update"

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'pages#index'
  get 'pages/show'
end
