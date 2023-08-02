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
    function.subtract_to_add_minus
    # function.save
    differential = classify_terms(function)
    function.set_first_differential(differential)
    # debugger
    ans   = string_to_array(function.expression)
  end
  
  private

  def is_integer?(term)
    term.to_s.to_i.to_s == term
  end
    
  def classify_terms(function)
    terms_hash = {}
    diff_ans  = []
    terms_arr = function.expression.split('+')
    terms_arr.each{ |term| 
      func = Function.new(expression: term)
      func.classify_function
      terms_hash[term] = func.classification
      compound = compound_term?(term)
      differentiate_product_rule(func) if !compound[:typef].blank? && compound[:typef] == "product-rule"
      # debugger
      # diff_ans.append(differentiate(func).first)
    } 
    # diff_ans.delete("0")
    # diff_ans.each {|inst| inst.prepend('('); inst.concat(')')  }
    # diff_ans.join('+')
  end

  def differentiate(func)
    final_ans  = []
    if func.classification == "simple"
      index = get_index(func.expression)
      coef  = get_coefficient(func.expression)
      const = false
      func.expression.include?('x') ? const = false : const = true
      der = differentiate_simple({coef: coef, index: index, constant: const})
      final_ans.append(der[:func])
    else
      body    = get_body(func.expression).first
      i_index = get_index(body)
      i_coef  = get_coefficient(body)
      expression = func.expression
      if func.classification == "trigonometric"
        typef = get_type(func.expression)
        expression.remove!("#{typef}(#{body})")
        o_index = get_index(expression)
        o_coef  = get_coefficient(expression)
        der = differentiate_trigonometric({o_coef: o_coef, i_coef: i_coef, o_index: o_index, i_index: i_index, body: body, typef: typef})
        final_ans.append(der[:func])
      elsif func.classification == "exponential"
        expression.remove!("exp","(#{body})")
        o_index = get_index(expression)
        o_coef  = get_coefficient(expression)
        der = differentiate_exponential({o_coef: o_coef, i_coef: i_coef, o_index: o_index, i_index: i_index, body: body})
        final_ans.append(der[:func])
      elsif func.classification == "natural_log"
        expression.remove!("ln","(#{body})")
        o_index = get_index(expression)
        o_coef  = get_coefficient(expression)
        der = differentiate_natural_log({o_coef: o_coef, i_coef: i_coef, o_index: o_index, i_index: i_index, body: body})
        final_ans.append(der[:func])
      elsif func.classification == "logarithmic"
        expression.remove!("log","(#{body})")
        o_index = get_index(expression)
        o_coef  = get_coefficient(expression)
        der = differentiate_logarithmic({o_coef: o_coef, i_coef: i_coef, o_index: o_index, i_index: i_index, body: body})
        final_ans.append(der[:func])
      end
    end
    final_ans
    
  end

  def get_index(term)
    return "1" unless term.include?('^')
    term_parts = term.split('^')
    index      = term_parts.last
    index.remove!('(', ')')
    index
  end

  def get_coefficient(term)
    return "1" if term.blank?
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
    # term_parts#.last
    ans = []
    term_parts.each_with_index do |part, index|
      ans.append(part) if index%2 != 0
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

  def compound_term?(term)
    return {compound: false} if !term.include?('(')

    term_parts = term.split('*')
    term_num   = term_parts.length

    if term_parts.length > 1
      term_parts.each {|part| term_num -= 1 if is_integer?(part)}
      term_num > 1 ? {compound: true, typef: 'product-rule'} : {compound: false}
    elsif term_parts.length == 1
      t = get_type(term)
      if t == "sin" || t == "cos" || t == "tan" || t == "csc" || t == "sec" || t == "cot"
        term_parts.first.include?('^') ? {compound: true, typef: 'chain-rule'} : {compound: false}
      else
        return {compound: false}
      end
    end
  end

  def differentiate_simple(hash)
    return {func:'0'} if hash[:constant] 
    ans = ''
    if hash[:index].to_i == 2
      ans.concat((hash[:coef].to_i* hash[:index].to_i).to_s, 'x')
    elsif hash[:index].to_i != 1
      ans.concat((hash[:coef].to_i* hash[:index].to_i).to_s, 'x^', (hash[:index].to_i - 1).to_s)
    else
      ans.concat(hash[:coef])
    end
    {func: ans}
  end

  def differentiate_trigonometric(hash)
    ans = {}
    if hash[:o_index] == "1"
      index = get_index(hash[:body])
      coef  = get_coefficient(hash[:body])
      forst = differentiate_simple({coef: coef, index: index, constant: hash[:const]})
      first = forst[:func].split(Regexp.union(['x^','x']))
      func  = ''
      typef = hash[:typef].to_s
      typef == "sin" ? func = "cos(#{hash[:body]})"                     : typef == "cos" ? func = "sin(#{hash[:body]})"                    : typef == "tan" ? func = "sec^2(#{hash[:body]})" : func.concat('')
      typef == "csc" ? func = "csc(#{hash[:body]})*cot(#{hash[:body]})" : typef == "sec" ? func = "sec(#{hash[:body]})*tan(#{hash[:body]})": typef == "cot" ? func = "csc^2(#{hash[:body]})" : func.concat('')
      ans   = {func: func.prepend((first.first.to_i*hash[:o_coef].to_i).to_s)}
      ans   = {func: func.prepend('-')} if typef == "cos" || typef == "csc" || typef == "cot"
    else
      ans = {}
    end
    ans
  end

  def differentiate_exponential(hash)
    ans = {}
    if hash[:o_index] == "1"
      index = get_index(hash[:body])
      coef  = get_coefficient(hash[:body])
      forst = differentiate_simple({coef: coef, index: index})
      first = forst[:func].split(Regexp.union(['x^','x']))
      ans = {func: "#{(first.first.to_i*hash[:o_coef].to_i).to_s.concat(forst[:func].remove!(first.first))}exp(#{hash[:body]})"}
    end
  end

  def differentiate_natural_log(hash)
    ans = {}
    if hash[:o_index] == "1"
      if hash[:i_index] == "1"
        ans = {func:"#{hash[:o_coef]}/x"}
      else
        ans = {func:"#{hash[:o_coef].to_i*hash[:i_index].to_i}/x"}
      end
      ans
    end
  end

  def differentiate_logarithmic(hash)
    ln_ans = differentiate_natural_log(hash)
    ln_ans_parts = ln_ans[:func].split("/")
    ln_ans_parts.last.prepend("(")
    ln_ans_parts.last.concat("*ln(10))")
    ans = {func: "#{ln_ans_parts.first}/#{ln_ans_parts.last}"}
  end

  def differentiate_product_rule(func)
    term_parts = func.expression.split('*')
    differentials = []
    term_parts.each {|part|
      sub_func = Function.new(expression: part)
      sub_func.classify_function
      differentials.append(differentiate(sub_func).first)
    }
    term_parts.each    {|t| t.prepend('('); t.concat(')')}
    differentials.each {|d| d.prepend('('); d.concat(')')}
    ans = "#{term_parts.first}*#{differentials.last} + #{term_parts.last}*#{differentials.first}"
    debugger
  end

  def differentiate_quotient_rule
  end

  def differentiate_chain_rule
  end



  def string_to_array(string)
    array = []
    delimiters = ['+','-']
    terms_arr  = string.split(Regexp.union(delimiters))
    terms_arr.each { |term|
      parts = term.split('^')
    }

    terms_arr
  end

  def get_coefficients_and_indices(term)
    delimiters = ['*','^']
    terms_arr  = term.split(Regexp.union(delimiters))
  end

end

