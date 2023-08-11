Rails.application.routes.draw do
  get    '/vectors/new',     to: 'vectors#new',     as: 'new_vector'
  post   '/vectors/new',     to: 'vectors#create',  as: 'create_vector'
  delete '/vectors/destroy', to: 'vectors#destroy', as: 'destroy_vector'

  get    '/equations/new',     to: 'equations#new',     as: 'new_equation'
  post   '/equations/new',     to: 'equations#create',  as: 'create_equation'
  delete '/equations/destroy', to: 'equations#destroy', as: 'destroy_equation'
  
  get    '/conversions/new',    to: 'conversions#new',     as: 'new_conversions'
  post   '/conversions/new',    to: 'conversions#create',  as: 'create_conversions'
  delete '/conversions/destroy',to: 'conversions#destroy', as: 'destroy_conversions'

  get    '/new_function',     to: 'functions#new'
  post   '/new_function',     to: 'functions#create'
  delete '/destroy_function', to: 'functions#destroy'

  get    '/new_sequence',     to: 'sequences#new'
  post   '/new_sequence',     to: 'sequences#create'
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

  equations:
    x^2 + x -2 = x -1
    x^2 + 2x -15 = 0

=end
=begin
  expansion ideas:
    tick:: 1 convert between coordinate systems:
      rectagular
      cylindrical 
      spherical

    2 Newton-Raphson Method

    3 Upload identities to  API

    tick:: 4 Equation Solver


=end