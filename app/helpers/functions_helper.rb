module FunctionsHelper

  identities = {}
  identities[:"sin(2x)"]  = "2sin(x)*cos(x)"
  identities[:"cos^2(x)"] = "1 - sin^2(x)"
  identities[:"sin^2(x)"] = "1 - cos^2(x)"
  identities[:"sin^2(x)+cos^2(x)"] = "1"
  
  def perfect_square(value)
    return false if !is_integer?(value)
    value == Math.sqrt(value.to_i) * Math.sqrt(value.to_i)
  end

  def fix_double_negative(string)
  end

  def cleanup_string_format(string)
    ans = ''
    arr = string.split('')
    arr.each_with_index{ |a, i|
      if !(a == '+' && i != 0 && arr[i-1] == '(')
        if !(a == ')' && arr[i-1] == '(')
          ans.concat(a) if !(a == '+' && i == 0)
        end
      end
    }
    ans
  end

  def is_integer?(term)
    term.to_s.to_i.to_s == term
  end

  def get_index(term)
    return "1" unless term.include?('^')
    term_parts = term.split('^')
    index      = term_parts.last
    index.remove!('(', ')')
    index
  end

  def get_coefficient(term)
    return "1"  if term.blank?
    return "-1" if term == "-"
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
    return {compound: true, typef: 'quotient-rule'} if term.include?('/')
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
end
