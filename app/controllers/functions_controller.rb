class FunctionsController < ApplicationController
  def new
    @function = Function.new
  end

  def create
    function = Function.new(expression: params[:function][:expression])
    function.expression = params[:function][:expression]
    function.classify_function
    function.remove_spaces
    function.save
    classify_terms(function)
  end
  
  private

  def is_integer?(term)
    term.to_i.to_s == term
  end
    
  def classify_terms(function)
    terms_hash = {}
    terms_arr  = function.expression.split('+')
    terms_arr.each{|term| 
      func = Function.new(expression: term)
      func.classify_function
      terms_hash[term] = func.classification
      differentiate_sum_rule(term) if func.classification == "arithmetic"
    }
    
  end

  def differentiate_sum_rule(term)
    term_part = term.split('^')
    if is_integer?(term.last )
      # multiply first integer with the index
    end
    # if term.last.ord >= 48 && term.last.ord < 58
  end

  def differentiate_product_rule
  end

  def differentiate_quotient_rule
  end

  def differentiate_chain_rule
  end

  def differentiate_trigonometric
  end

  def differentiate_logarithmic
  end

  def differentiate_exponential
  end
end

