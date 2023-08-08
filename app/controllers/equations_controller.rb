class EquationsController < ApplicationController

  def new
    @equation  = Equation.new
    @equations = Equation.all.order(id: :desc)
  end

  def create
    equation = Equation.new(expression: params[:equation][:expression])
    # debugger
    solution = solve(remove_spaces(equation.expression))
  end

  def destroy
    @equation = Equation.find(params[:id])
    @equation.destroy
    flash[:notice] = 'Equation destroyed'
    redirect_to new_equation_path
  end
  
  private

  def solve(expression)
    expression = add_addition_signs(expression)
    both = expression.split('=')
    lhs  = both.first
    rhs  = both.last
    #==================================================
    rhs_parts = rhs.split('+')
    rhs_parts.each {|part|
      lhs.concat('-',part)        if part.first != '-'
      lhs.concat('+',part[1..-1]) if part.first == '-'
    }
    rhs = '0'
    #==================================================
    lhs = add_tilde_signs(lhs)
    lhs_parts = lhs.split('~')
    power3 = []
    power2 = []
    power1 = []
    consts = []
    lhs_parts.each {|part|
      power3.append(part) if !part['^3'].blank?
      power2.append(part) if !part['^2'].blank?
      power1.append(part) if !part['x'].blank?  && part['x^'].blank?
      consts.append(part) if  part['x'].blank?
    }

    #==================================================
    power3 = simplify_like_terms(power3)
    power2 = simplify_like_terms(power2)
    power1 = simplify_like_terms(power1)
    consts = simplify_like_terms(consts)
    # debugger
    #==================================================
    lhs = ''
    if !power3.blank? && power3 != "0"
      power3 == '1' ? lhs.concat('x^3') : lhs.concat(power3,'x^3')
    end
    if !power2.blank? && power2 != "0"
      power2 == '1' ? lhs.concat('x^2') : lhs.concat(power2,'x^2')
    end
    if !power1.blank? && power1 != "0"
      power1 == '1' ? lhs.concat('x')   : lhs.concat(power1,'x')   
    end
    if !consts.blank? && consts != "0"
      lhs.concat(consts)
    end
    # debugger
    # lhs.concat(power3,'x^3') if !power3.blank? && power3 != "0"
    # lhs.concat(power2,'x^2') if !power2.blank? && power2 != "0"
    # lhs.concat(power1,'x')   if !power1.blank? && power1 != "0"
    # lhs.concat(consts)       if !consts.blank? && consts != "0"
    #==================================================
    lhs = add_tilde_signs(lhs)
    lhs_parts = lhs.split('~')
    power3 = []
    power2 = []
    power1 = []
    consts = []
    lhs_parts.each {|part|
      power3.append(part) if !part['^3'].blank?
      power2.append(part) if !part['^2'].blank?
      power1.append(part) if !part['x'].blank?  && part['^'].blank?
      consts.append(part) if  part['x'].blank?
    }

    #==================================================
    power3 = simplify_like_terms(power3)
    power2 = simplify_like_terms(power2)
    power1 = simplify_like_terms(power1)
    consts = simplify_like_terms(consts)

    lhs_coefs = []
    !power3.blank? ? lhs_coefs.append(power3.to_i) : lhs_coefs.append(0)
    !power2.blank? ? lhs_coefs.append(power2.to_i) : lhs_coefs.append(0)
    !power1.blank? ? lhs_coefs.append(power1.to_i) : lhs_coefs.append(0)
    !consts.blank? ? lhs_coefs.append(consts.to_i) : lhs_coefs.append(0)
    #==================================================
    # power3_facs = get_factor_pairs(lhs_coefs.first)
    power2_facs = get_factor_pairs(lhs_coefs.second)
    power1_facs = get_factor_pairs(lhs_coefs.third)
    consts_facs = get_factor_pairs(lhs_coefs.last)
    #==================================================
    debugger
  end

  def simplify_like_terms(terms)
    return if terms.blank?
    if terms.first['x'].blank?
      return (instance_eval terms.join('') ).to_s
    else
      exp  = terms.join('').split('')
      exp2 = ''
      exp.each_with_index {|e,i|
        e == 'x' ? (i >0 && exp[i-1].class != Integer) ? next : exp2.concat('1') : e == '^' ? exp2.concat('**') : exp2.concat(e) 
      }
      return (instance_eval exp2).to_s
    end
    
  end

  def verify_solution(expression, solution)
  end

  def valid_equation?(expression)
    cnt = 0
    let = expression.split('')
    let.each {|l| cnt += 1 if l == '='}
    cnt == 1 ? true : false
  end

  def get_factor_pairs(number)
    ans = []
    number.abs.times {|num|
      fac = number/(1+num)
      # ((num+1)*fac == number) ? ans.append([num+1,fac]) : ans.append(['not equal']) #if ((num+1)*fac == number) 
      ans.append([num+1,fac]) if ((num+1)*fac == number) 
    }
    ans
    # debugger
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
