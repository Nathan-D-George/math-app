class EquationsController < ApplicationController
  include  EquationsHelper

  def new
    @equation  = Equation.new
    @equations = Equation.all.order(id: :desc)
  end

  def create
    equation = Equation.new(expression: params[:equation][:expression])
    if valid_equation?(equation.expression)
      equation.solution = solve(remove_spaces(equation.expression))
      if equation.save
        flash[:notice] = 'Equation solved and saved'
      else
        flash[:alert] = 'Something went wrong with equation solving or saving'
      end
    else
      flash[:alert] = 'Please follow the rules stated below'
    end

    redirect_to new_equation_path
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
      next if part == ''
      lhs.concat('-',part)        if part.first != '-'
      lhs.concat('+',part[1..-1]) if part.first == '-'
    }
    rhs = '0'
    #==================================================
    
    lhs = add_tilde_signs(lhs)
    lhs_parts = lhs.split('~')
    power2 = []
    power1 = []
    consts = []
    lhs_parts.each {|part|
      power2.append(part) if !part['^2'].blank?
      power1.append(part) if !part['x'].blank?  && part['x^'].blank?
      consts.append(part) if  part['x'].blank?
    }
    #==================================================
    
    power2 = simplify_like_terms(power2)
    power1 = simplify_like_terms(power1)
    consts = simplify_like_terms(consts)
    #==================================================
    
    lhs = ''
    if !power2.blank? && power2 != "0"
      power2 == '1' ? lhs.concat('x^2') : lhs.concat(power2,'x^2')
    end
    if !power1.blank? && power1 != "0"
      if power1.to_i < 0
        lhs.concat(power1,'x')   
      else
        power1 == '1' ? lhs.concat('+x')   : lhs.concat('+',power1,'x')   
      end
    end
    if !consts.blank? && consts != "0"
      consts.to_i > 0 ? lhs.concat('+', consts) : lhs.concat(consts)
    end
    #==================================================

    lhs = add_tilde_signs(lhs)
    lhs_parts = lhs.split('~')
    power2 = []
    power1 = []
    consts = []
    lhs_parts.each {|part|
      power2.append(part) if !part['^2'].blank?
      power1.append(part) if !part['x'].blank?  && part['^'].blank?
      consts.append(part) if  part['x'].blank?
    }
    #==================================================
    
    power2 = simplify_like_terms(power2)
    power1 = simplify_like_terms(power1)
    consts = simplify_like_terms(consts)
    
    lhs_coefs = []
    !power2.blank? ? lhs_coefs.append(power2.to_i) : lhs_coefs.append(0)
    !power1.blank? ? lhs_coefs.append(power1.to_i) : lhs_coefs.append(0)
    !consts.blank? ? lhs_coefs.append(consts.to_i) : lhs_coefs.append(0)
    #==================================================

    power2_facs = get_factor_pairs(lhs_coefs.second)
    consts_facs = get_factor_pairs(lhs_coefs.last)
    #==================================================
    
    ans = ''
    if !power2.blank?
      factors_for_answer = complete_square(power2.to_i, power1.to_i, consts.to_i)
      ans = "x = #{factors_for_answer.first}, x = #{factors_for_answer.second}"
    else
      ans = "x = #{(-consts.to_f/power1.to_f).round(2)}"
    end
    ans
  end

  def simplify_like_terms(terms)
    return if terms.blank?
    if terms.first['x'].blank?
      return (instance_eval terms.join('') ).to_s
    else
      exp  = terms.join('').split('')
      exp2 = ''
      exp.each_with_index {|e,i|
        if e == 'x'
          if (i >0 && exp[i-1].class != Integer)
            exp[i-1] == '-' ? exp2.concat('-1') : exp2.concat('1')
          else
            exp2.concat('1')
          end
        elsif e == '^'
          exp2.concat('**')
        elsif e == '+' || e == '-'
          exp2.concat('+')
        else
          if !exp[i+1].blank? && exp[i+1] == 'x'
            exp2.concat(e,'*')
          else
            exp2.concat(e)
          end
        end
      }
      exp2 = exp2[1..-1] if exp2.first == '+' 
      return (instance_eval exp2).to_s
    end
    
  end

  def valid_equation?(expression)
    cnt = 0
    let = expression.split('')
    let.each {|l| cnt += 1 if l == '='}
    return false if cnt != 1 
    return false if !expression["^3"].blank?
    return false if !expression["/0"].blank?
    true
  end

  def factorize_quadratic_equation(coefs_2, coefs_c, ans)
    coefs_c.each {|const_factors|
      attempt1 = coefs_2.first.first* const_factors.second      + coefs_2.first.second* const_factors.first
      attempt2 = coefs_2.first.first* const_factors.second*(-1) + coefs_2.first.second* const_factors.first*(-1)
      return const_factors if attempt1 == ans
      return [(-1)*const_factors.first, (-1)* const_factors.second] if attempt2 == ans
    }
  end

  def complete_square(a,b,c)
    if (b.to_f*b.to_f - 4*a.to_f*c.to_f) >= 0
      ans1 = (-b.to_f/(2*a) + Math.sqrt(b.to_f*b.to_f - 4*a.to_f*c.to_f).to_f/(2*a)).round(2)
      ans2 = (-b.to_f/(2*a) - Math.sqrt(b.to_f*b.to_f - 4*a.to_f*c.to_f).to_f/(2*a)).round(2)
      return [ans1, ans2]
    else
      ans1 = "#{-b.to_f/(2*a)} + i#{(Math.sqrt(4*a.to_f*c.to_f - b.to_f*b.to_f ).to_f/(2*a)).round(2)}"
      ans2 = "#{-b.to_f/(2*a)} - i#{(Math.sqrt(4*a.to_f*c.to_f - b.to_f*b.to_f ).to_f/(2*a)).round(2)}"
      return [ans1, ans2]
    end    
  end

end
