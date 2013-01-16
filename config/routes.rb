Misesajour::Application.routes.draw do
  resources :followers

  get 'paypal/success' => 'private#paypal_ok'
  get 'paypal/failed' => 'private#paypal_failed'

  resources :rt_twitts, :only => [:show, :create, :new, :update]

  get "dashboard" => "private#dashboard", :as => :dashboard

  resources :user_twitters

  resources :rss_items

  resources :rss_providers

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}, path: ''
  get "pricing" => 'public#pricing', :as => :pricing_en
  get "tarifs"  => 'public#pricing', :as => :pricing_fr
  root :to => 'public#index'
  match "*a" => redirect('/')
end
