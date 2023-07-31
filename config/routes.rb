Rails.application.routes.draw do
  get  '/new_function', to: 'functions#new'
  post '/new_function', to: 'functions#create'

  root to: 'pages#home'
  get '/about', to: 'pages#about'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
=begin
  Jehovah
  Yahweh
  Yahweh will Manifest
  Yeshua
  Who is this man?
  Good (can't be anything else)
  Coming back
=end