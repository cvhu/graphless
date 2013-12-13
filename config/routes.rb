Graphless::Application.routes.draw do

  root :to => 'pages#landing'
  match '/login' => 'pages#login'
  match '/signup' => 'pages#signup'

  match '/api/users/signup' => 'users#signup'

end