Rails.application.routes.draw do
  get  '/new_function',  to: 'functions#new'
  get  '/make_function', to: 'functions#make' 
  post '/new_function',  to: 'functions#create'

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

  chain-rule:
    sin(3x^2)
    sin^2(3x)

=end

