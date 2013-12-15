Graphless::Application.routes.draw do

  root :to => 'pages#landing'

  match '/login' => 'pages#login'
  match '/signup' => 'pages#signup'

  match '/@:username' => 'users#profile'
  match '/api/users/signup' => 'users#signup'
  match '/api/users/login' => 'users#login'
  match '/api/users/logout' => 'users#logout'
  match '/api/users/header' => 'users#header'
  match '/api/users/widget' => 'users#widget'

end