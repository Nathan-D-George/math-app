class VectorsController < ApplicationController
  def new
    @vector = Vector.new
    @vectors = Vector.all.order(id: :desc)
  end
  
  def create
    vector = Vector.new
    vector.i = params[:vector][:i].to_i
    vector.j = params[:vector][:j].to_i
    vector.k = params[:vector][:k].to_i
    vector.magnitude = calculate_magnitude(vector.i, vector.j, vector.k)
    if vector.save
      flash[:notice] = 'Successfully mad vector'
    else 
      flash[:alert] = 'Something went wrong'
    end
    redirect_to new_vector_path
  end

  def destroy
    @vector = Vector.find(params[:id])
    @vector.destroy
    flash[:notice] = 'Vector successfully destraoyed'
    redirect_to new_vector_path
  end
  
  private

  def calculate_magnitude(i,j,k)
    return (Math.sqrt(i*i + j*j + k*k))
  end

  def dot_product(vector1, vector2)
    return ( (vector1.i*vector2.i) + (vector1.j*vector2.j) + (vector1.k*vector2.k) )
  end

  def crosss_product(vector1, vector2)
    ans = Vector.new
    ans.i =  (vector1.j*vector2.k - vector1.k*vector2.j)
    ans.j = -(vector1.i*vector2.k - vector1.k*vector2.i)
    ans.k =  (vector1.i*vector2.j - vector1.j*vector2.i)
    ans.magnitude = calculate_magnitude(ans.i, )
  end
end
