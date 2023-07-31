class Function < ApplicationRecord
  enum integration: %i[substituion by_parts sine_powers trig_substituion rational_functions numerical_integration]
  enum classification: %i[arithmetic trigonometric exponential logarithmic]
  
end
