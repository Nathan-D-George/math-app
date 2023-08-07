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
=begin
  More than Able
  Firm Foundation
  Jehovah
  Yahweh
  Yahweh will Manifest
  Yeshua
  Who is this man?
  Good (can't be anything else)


  simple:
    x^2 + 3ln(x) - sin(2x)
    exp(4x^2)

  product-rule:
    ln(x) * sin(2x)
    2x * exp(4x)
     x * exp(x)

  quotient-rule
    ln(x)/2x^3
    sec(3x^2)/(2x+1)

  chain-rule:
    sin(3x^2)
    sin^2(3x)

=end

