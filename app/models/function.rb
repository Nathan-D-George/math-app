class Function < ApplicationRecord

  # if conndition then "Yes" else "No" end

  enum integration: %i[substitution by_parts sine_powers trig_substituion rational_functions numerical_integration]
  enum classification: %i[arithmetic trigonometric exponential logarithmic]
   
  def classify_function
    parts = self.expression.split('+')
    self.classification = "arithmetic"    if arithmetic?(parts)
    self.classification = "trigonometric" if trigonometric?(parts)
    self.classification = "logarithmic"   if logarithmic?(parts)
    self.classification = "exponential"   if exponential?(parts)
  end

  def remove_spaces
    expr  = ''
    array = self.expression.split('')
    array.each{|arr|
      expr.concat(arr) if arr != ' '
    }
    self.expression = expr
  end

  private
  def arithmetic?(parts)
    parts.each{|part|
      return false if part.include?('sin') || part.include?('cos') || part.include?('tan')
      return false if part.include?('csc') || part.include?('sec') || part.include?('cot')
      return false if part.include?('ln')  || part.include?('log') || part.include?('exp')
    }
    true
  end

  def trigonometric?(parts)
    # parts = expr.split('+')
    parts.each{|part|
      return true if part.include?('sin') || part.include?('cos') || part.include?('tan')
      return true if part.include?('csc') || part.include?('sec') || part.include?('cot')
    }
    false
  end

  def logarithmic?(parts)
    # parts = expr.split('+')
    parts.each{|part|
      return true if part.include?('ln')  || part.include?('log')
    }
    false
  end

  def exponential?(parts)
    # parts = expr.split('+')
    parts.each{|part|
      return true if part.include?('exp')
    }
    false
  end

end
