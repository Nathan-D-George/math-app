Rails.application.routes.draw do
  get  '/new_function',  to: 'functions#new'
  get  '/make_function', to: 'functions#make' 
  post '/new_function',  to: 'functions#create'
  delete '/destroy_function', to: 'functions#destroy'

  get '/new_sequence', to: 'sequences#new'
  post'/new_sequence', to: 'sequences#create'
  delete '/destroy_sequence', to: 'sequences#destroy'

  root to: 'pages#home'
  get '/about', to: 'pages#about'
  

end

