class FunctionsController < ApplicationController

  def new
    @function = Function.new
  end

  def create
    debugger
    function = Function.new
    function.expresssion = params[:expression]
    function.classification = type_of_function
    function.integral_answer
  end
  
  private
  
  def type_of_function
  end

  def integral_answer
  end

end
