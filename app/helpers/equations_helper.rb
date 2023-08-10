module EquationsHelper

  def get_factor_pairs(number)
    ans = []
    number.abs.times {|num|
      fac = number/(1+num)
      ans.append([num+1,fac]) if ((num+1)*fac == number) 
    }
    ans
  end

  def remove_spaces(expression)
    let = expression.split('')
    ans = ''
    let.each {|l| ans.concat(l) if l != ' '}
    ans
  end
  
  def add_addition_signs(expression)
    let = expression.split('')
    ans = ''
    let.each {|l|
      ans.concat('+') if l == '-'
      ans.concat(l)
    }
    ans
  end

  def add_tilde_signs(expression)
    let = expression.split('')
    ans = ''
    let.each {|l|
      ans.concat('~') if l == '-' || l == '+'
      ans.concat(l)
    }
    ans
  end
  
end
