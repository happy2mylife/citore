Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/auth/:provider/callback" => "sns#oauth_callback"

  resource :sns, controller: :sns, only: [] do
    get :admin_index
  end

  resource :apk_downloader, controller: :apk_downloader, only: [] do
    get 'warakatsu'
    get 'citore'
  end

  resources :fey_kun, controller: :fey_kun, only: [] do
    member do
      get 'report'
    end

    collection do
      post 'analized'
    end
  end

  resource :variable_template, controller: :variable_template, only: [] do
    get 'warakatsu_apk_download'
    get 'citore_apk_download'
    get 'citore_movie'
    get 'citore_slide'
    get 'marionette_movie'
    get 'marionette_slide'
  end

  resources :wssample, controller: :wssample, only: [:index]

  namespace :sugarcoat do
    resource :bot, controller: :bot, only: [] do
      get 'speak'
      get 'callback'
      post 'callback'
      get 'linebot_callback'
      post 'linebot_callback'
    end

    resource :landing, controller: :landing, only: [] do
      get 'page'
      get 'page01'
      get 'page02'
      get 'page03'
    end
  end

  namespace :citore do
    resource :voice, controller: :voice, only: [] do
      get 'download'
    end

    resources :words, only: [:index] do
      collection do
        get 'search'
      end
    end
  end

  namespace :bots do
    resource :line, controller: :line, only: [] do
      get :sugarcoat
      post :sugarcoat
      get :citore
      post :citore
      get :spotgacha
      post :spotgacha
      get :job_with_life
      post :job_with_life
      get :shiritori
      post :shiritori
      get :mone
      post :mone
    end

    resource :facebook, controller: :facebook, only: [] do
      get :sugarcoat
      post :sugarcoat
      get :citore
      post :citore
      get :spotgacha
      post :spotgacha
      get :job_with_life
      post :job_with_life
      get :shiritori
      post :shiritori
      get :mone
      post :mone
    end

    resource :selection, controller: :selection, only: [] do
      get :spotgacha
    end
  end

  namespace :tools do
    root to: "top#index"

    resource :graphics, controller: :graphics, only: [] do
      get :canvas
      get :threed
      get :base64
    end

    resource :texture_packer, controller: :texture_packer, only: [] do
      get :index
      post :pack
    end

    resource :image_crawl, controller: :image_crawl, only: [] do
      get :index
      post :crawl
    end

    resource :excel_converter, controller: :excel_converter, only: [] do
      get :index
      post :convert_to_json
    end

    resource :twitter, controller: :twitter, only: [] do
      get :index
      get :input_user
      post :only_follower_users
      post :only_following_users
      post :remove_followers
      post :crawl_user_all_tweet
    end

    resources :webrtcs, only: [:index] do
      collection do
        get :freedom_videochat
      end
    end

    resources :websockets, only: [:index] do
      collection do
        get :twitter_sample
      end
    end
  end

  namespace :unibo do
    resource :talk, controller: :talk, only: [] do
      get :index
      get :input
      get :say
      post :say
    end
  end

  namespace :bannosama do
    root to: "top#index"

    resources :photos, only: [:index] do
      collection do
        post :upload
      end
    end

    resources :greets, controller: :greets, only: [] do
      collection do
        get :list
        get :mode_change
      end

      member do
        get :receive
      end
    end
  end

  namespace :food_forecast do
    root to: "top#index"

    resource :top, controller: :top, only: [] do
      post :send_location
    end

    resource :auth, controller: :auth, only: [] do
      post :login
      post :logout
      post :signup
    end

    resources :settings, only: [] do
      collection do
        get :input
        post :register
      end
    end
  end

  scope module: :homepage do
    resource :profile, controller: :profile, only: [] do
      get :index
    end

    resources :products, only: [:index, :show]
    resources :relations, only: [:index]
    resources :articles, only: [:index]

    resource :contact, controller: :contact, only: [] do
      get :index
    end

    resource :top, controller: :top, only: [] do
      post :regist_visitor
    end

  end

  root to: "homepage/top#index"
end
