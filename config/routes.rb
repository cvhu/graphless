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

  match '/apps/new' => 'apps#new'
  match '/api/apps/create' => 'apps#create'
  match '/api/apps/list' => 'apps#list'

  match '/api/models/create' => 'models#create'
  match '/api/models/list' => 'models#list'
  match '/api/models/view' => 'models#view'

  match '/api/mnodes/create' => 'mnodes#create'

  match '/api/events/create' => 'events#create'
end