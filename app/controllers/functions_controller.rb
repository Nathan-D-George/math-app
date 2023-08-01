class FunctionsController < ApplicationController
  def new
    @function = Function.new
    console
  end

  def make
    @function = Function.new
  end

  def create
    function = Function.new(expression: params[:function][:expression])
    function.expression = params[:function][:expression]
    function.classify_function
    function.remove_spaces
    # function.save
    classify_terms(function)
    ans   = string_to_array(function.expression)
    # debugger
  end
  
  private

  def is_integer?(term)
    term.to_s.to_i.to_s == term
  end
    
  def classify_terms(function)
    terms_hash = {}
    delimiters = ['+','-']
    terms_arr  = function.expression.split(Regexp.union(delimiters))
    terms_arr.each{|term| 
      func = Function.new(expression: term)
      func.classify_function
      terms_hash[term] = func.classification
      if func.classification == "simple"
        index = get_index(func.expression)
        coef  = get_coefficient(func.expression)
        der = differentiate_simple({coef: o_coef, index: o_index})
        debugger
      else
        body  = get_body(func.expression)
        i_index = get_index(body)
        i_coef  = get_coefficient(body)
        expression = func.expression
        expression.remove!('^')
        o_index = get_index(expression)
        o_coef  = get_coefficient(expression)
        typef = get_type(func.expression)
        der = differentiate_trigonometric({o_coef: o_coef, i_coef: i_coef, o_index: o_index, i_index: i_index, body: body, typef: typef})
        debugger
      end
      # der = differentiate_simple({coef: o_coef, index: o_index}) if func.classification == "simple"
      # der = differentiate_trigonometric({coef: coef, index: index, body: body, typef: typef}) if func.classification == "trigonometric"
      
    }
  end

  def get_index(term)
    return "1" unless term.include?('^')
    term_parts = term.split('^')
    index      = term_parts.last
    index.remove!('(', ')')
    index
  end

  def get_coefficient(term)
    return term unless term.include?('x')
    term_parts = term.split('x')
    coef = "1"
    term_parts.each {|part|
      coef = part if is_integer?(part)
    }
    coef.to_s
  end

  def get_body(term)
    delimiters = ['(',')']
    term_parts = term.split(Regexp.union(delimiters))
    term_parts.last
  end

  def differentiate_simple(hash)
    ans = ''
    if hash[:index].to_i == 2
      ans.concat((hash[:coef].to_i* hash[:index].to_i).to_s, 'x')
    elsif hash[:index].to_i != 1
      ans.concat((hash[:coef].to_i* hash[:index].to_i).to_s, 'x^', (hash[:index].to_i - 1).to_s)
    else
      ans.concat(hash[:coef])
    end
    ans
  end

  def differentiate_trigonometric(hash)
    ans = {}
    if hash[:o_index] == "1"
      index = get_index(hash[:body])
      coef  = get_coefficient(hash[:body])
      forst = differentiate_simple({coef: coef, index: index})
      # first.remove!('x') if first.last == 'x'
      first = forst.split(Regexp.union(['x^','x']))
      # debugger
      func = ''
      typef = hash[:typef].to_s
      typef == "sin" ? func = "cos(#{hash[:body]})" : typef == "cos" ? func = "-sin(#{hash[:body]})": typef == "tan" ? func = "sec^2(#{hash[:body]})" : func.concat('')
      typef == "csc" ? func = "-csc(#{hash[:body]})*cot(#{hash[:body]})" : typef == "sec" ? func = "sec(#{hash[:body]})*tan(#{hash[:body]})": typef == "cot" ? func = "-csc^2(#{hash[:body]})" : func.concat('')
      ans = {first: (first.first.to_i*hash[:o_coef].to_i).to_s.concat(forst.remove!(first.first)), func: func}
    else
      ans = {}
    end
    ans
  end

  def get_type(term)
    return 'sin' if term.include?('sin')
    return 'cos' if term.include?('cos')
    return 'tan' if term.include?('tan')
    return 'csc' if term.include?('csc')
    return 'sec' if term.include?('sec')
    return 'cot' if term.include?('cot')
    return 'exp' if term.include?('exp')
    return 'log' if term.include?('log')
    return 'ln'  if term.include?('ln')
  end

  def differentiate_sum_rule(term)
    term_part = term.split('^') 
    # if is_integer?(term.last)
    if term_part.length > 1
      # multiply first integer with the index
      # term_part.each{|part|
        
      # }
      return 1
    elsif term_part.length == 1
      return 0 if is_integer?(term_part)
    end
    # end
    # if term.last.ord >= 48 && term.last.ord < 58
  end

  def differentiate_product_rule
  end

  def differentiate_quotient_rule
  end

  def differentiate_chain_rule
  end

  def differentiate_logarithmic
  end

  def differentiate_exponential
  end

  def string_to_array(string)
    array = []
    delimiters = ['+','-']
    terms_arr  = string.split(Regexp.union(delimiters))
    terms_arr.each { |term|
      parts = term.split('^')
    }
    # terms_arr.each{|term|
    #   special  = 0 
    #   special += 1 if term.include?('sin')
    #   special += 1 if term.include?('cos')
    #   special += 1 if term.include?('tan')
    #   special += 1 if term.include?('asin')
    #   special += 1 if term.include?('acos')
    #   special += 1 if term.include?('atan')
    #   special += 1 if term.include?('exp')
    #   special += 1 if term.include?('log')
    #   special += 1 if term.include?('ln')
    #   debugger
    # }
    terms_arr
  end

  def get_coefficients_and_indices(term)
    delimiters = ['*','^']
    terms_arr  = term.split(Regexp.union(delimiters))
  end
end

