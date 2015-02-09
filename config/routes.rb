Rails.application.routes.draw do
  root :to => 'pages#home'
  resources :users, :only => [:new, :create, :index]

  get '/games/new' => 'games#new'
  # to do: add user id to path for greater verification
  post '/games/:game_id/:turn_id/roll_again' => 'games#roll_again'
  post '/games/:game_id/:turn_id/enter_score' => 'games#enter_score'
  # todo: merge games#new_turn with games#new
  get '/games/:game_id/new_turn' => 'games#new_turn'
  get '/games/game_over' => 'games#game_over'

  get '/login' => 'session#new'
  post '/login' => 'session#create'
  delete '/login' => 'session#destroy'

end
