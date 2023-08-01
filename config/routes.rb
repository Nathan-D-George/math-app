Rails.application.routes.draw do
  get  '/new_function',  to: 'functions#new'
  get  '/make_function', to: 'functions#make' 
  post '/new_function',  to: 'functions#create'

  root to: 'pages#home'
  get '/about', to: 'pages#about'
  

end
=begin
  Jehovah
  Yahweh
  Yahweh will Manifest
  Yeshua
  Who is this man?
  Good (can't be anything else)
=end