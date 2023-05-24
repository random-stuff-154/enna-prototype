Rails.application.routes.draw do
  get 'habit_trackers/show'
  get 'habit_goals/new'
  get 'habit_goals/create'
  get 'users/update'
  get 'users/edit'
  post '/abstinence_goals/:user_id/relapse', to: 'abstinence_goals#relapse', as: :relapse
  post 'abstinence_goals/:user_id/relapse/:tracker_id', to: 'abstinence_goals#relapse', as: :abstinence_goal_relapse

  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  delete '/chats/:chat_id/messages', to: 'messages#destroy', as: 'destroy_chat_messages'
  root "pages#home"
  resources :chats, only: :show do
    resources :messages, only: :create
  end

  resources :abstinence_goals, only: [:new, :create]
  resources :habit_goals, only: [:new, :create]

  resources :users, only: [:edit, :update]
  resources :abstinence_trackers, only: [:index, :edit, :update]
  resources :habit_trackers, only: [:index, :edit, :update]
end