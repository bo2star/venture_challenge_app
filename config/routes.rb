Rails.application.routes.draw do

  concern :sortable do
    put 'sort', on: :collection
  end

  # Ops

  namespace :ops, path: '/', constraints: { subdomain: 'ops' } do
    mount Coupons::Engine => '/', as: 'coupons_engine'

    root to: redirect('/instructors')

    resources :instructors, only: [:index, :show, :create, :destroy] do
      put :assume, on: :member
      put :seed_competition, on: :member
    end

    resources :students, only: [:index] do
      put :assume, on: :member
    end

    resources :competitions, only: [:index, :show, :destroy] do
      put :seed_student, on: :member
    end

  end


  # Instructors

  namespace :admin, path: '/', constraints: { subdomain: 'admin' } do

    root to: redirect('/competitions')

    # Authentication
    get 'logout', to: 'sessions#destroy', as: 'logout'
    get 'login', to: 'sessions#new', as: 'login'
    get 'login_with_password', to: 'sessions#new_with_password', as: 'login_with_password'
    post 'session', to: 'sessions#create', as: 'session'

    # Registration
    get 'signup', to: 'registrations#new', as: 'signup'
    get 'signup_with_password', to: 'registrations#new_with_password', as: 'signup_with_password'
    post 'registration', to: 'registrations#create', as: 'registration'

    # LinkedIn OAuth
    get 'auth/linkedin/callback',   to: 'linkedin_authentications#create'
    # If something goes wrong during linked in authentication (e.g. the user cancels). We are redirected to
    # "/auth/failure?strategy=linkedin".
    get 'auth/failure', to: 'linkedin_authentications#failure', constraints: -> (req) { req.params[:strategy] == 'linkedin' }

    resources :competitions do
      get 'leaderboard', on: :member
      get 'history', on: :member
      get 'download_coursepack', on: :collection
    end

    resources :knowledgebase, only: [:index, :show]

    resources :teams, only: :show do
      resources :team_comments
    end

    resources :team_learning_resources, only: :show

    resources :learning_resources, except: :destroy, concerns: :sortable do
      put 'publish', on: :member
      put 'unpublish', on: :member

      resources :tasks, controller: 'learning_resource_tasks', concerns: :sortable
      resources :questions, controller: 'learning_resource_questions', concerns: :sortable

    end

  end


  # Students

  namespace :student, path: '/', as: nil, constraints: { subdomain: 'app' } do

    root to: redirect('/team')

    # Authentication
    get 'logout', to: 'sessions#destroy', as: 'logout'
    get 'login', to: 'sessions#new', as: 'login'
    get 'login_with_password', to: 'sessions#new_with_password', as: 'login_with_password'
    post 'session', to: 'sessions#create', as: 'session'

    # Registration
    get '/join/:token', to: 'registrations#new', as: 'join'
    get '/join_with_password/:token', to: 'registrations#new_with_password', as: 'join_with_password'
    post 'registration', to: 'registrations#create', as: 'registration'

    # LinkedIn OAuth
    get 'auth/linkedin/callback',   to: 'linkedin_authentications#create'
    # If something goes wrong during linked in authentication (e.g. the user cancels). We are redirected to
    # "/auth/failure?strategy=linkedin".
    get 'auth/failure', to: 'linkedin_authentications#failure', constraints: -> (req) { req.params[:strategy] == 'linkedin' }

    # Shopify OAuth
    get 'auth/shopify/callback', to: 'shops#auth_success'
    # Omniauth failures not handled by authentication must be from shopify
    # (invalid shopify urls?).
    get 'auth/failure', to: 'shops#auth_failure'
    get 'shop_confirmation_callback', to: 'shops#confirmation_callback'

    resource :team do
      resource :membership, only: [:new, :create, :destroy]
    end

    resources :tasks, only: [:index, :update]

    resources :team_comments

    resources :team_learning_resources, only: [:show, :update] do
      resources :tasks, controller: 'team_learning_resource_tasks', only: [:index, :update]
      resources :questions, controller: 'team_learning_resource_questions', only: [:index, :update]
    end

    resource :shop

    resource :leaderboard, controller: 'competitions' do
      get 'history', on: :collection
    end

    resource 'financials', only: [:show, :update]

  end

  # Global

  resources :shopify_webhooks, only: :create

end
