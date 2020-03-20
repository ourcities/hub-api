Rails.application.routes.draw do
  root 'root#index'
  post '/postbacks' => 'postbacks#create', as: :create_postback
  resources :notifications, only: [:show]
  resources :mobilizations, only: [:index, :create, :update] do
    get :published, on: :collection
    resources :blocks, controller: 'mobilizations/blocks', only: [:index, :create, :update, :destroy]
    put 'blocks', to: 'mobilizations/blocks#batch_update', as: 'update_blocks'
    resources :widgets, controller: 'mobilizations/widgets', only: [:index, :update]
    resources :form_entries, controller: 'mobilizations/form_entries', only: [:create, :index]
    resources :donations, controller: 'mobilizations/donations', only: [:create, :index]
  end

  resources :template_mobilizations, only: [:index, :destroy, :create], path: '/templates' do
  end

  resources :blocks, only: [:index]
  resources :widgets, only: [:index] do
    get :action_opportunities, on: :collection
    resources :fill, controller: 'widgets/fill', only: [:create]
  end

  resources :uploads, only: [:index]
  resources :communities, only: [:index, :create, :update, :show] do
    resources :dns_hosted_zones, except: [:new, :edit] do
      get 'check', to: 'dns_hosted_zones#check'
      resources :dns_records, except: [:new, :edit]
    end
    resources :activist_actions, only: [:index], controller: 'communities/activist_actions'
    resources :payable_details, only: [:index], controller: 'communities/payable_details'
    resources :donation_reports, only: [:index], controller: 'communities/donation_reports'
    resources :community_users, path: 'users', only: [:index, :create, :update]
    post 'resync_mailchimp', to: 'communities#resync_mailchimp'
    get 'mobilizations', to: 'communities#list_mobilizations'
    get 'activists', to: 'communities#list_activists'
    post 'download_activists', to: 'communities#list_activists'
    post 'download_subscriptions', to: 'communities#subscription_reports'
    post 'activists', to: 'activists#add_activists'
    post 'invitation', to: 'communities#create_invitation'
  end

  post '/register' => 'users#create', as: :user_register
  resources :users, only: [:create, :update]
  resources :subscriptions do
    post :recharge, on: :member
  end

  get '/invitation', to: 'communities#accept_invitation', as: 'accept_invitation'
  get '/convert-donation', to: 'convert_donations#convert'
  get '/replay-donation', to: 'convert_donations#replay'
  post '/retrieve', to: 'users#retrieve'
end
