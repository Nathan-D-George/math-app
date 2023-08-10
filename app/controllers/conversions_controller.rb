class ConversionsController < ApplicationController

  def new
    @function  = Conversion.new
    @functions = Conversion.all.order(id: :desc)
    @words = "rho = ρ; phi = φ; psi = ψ; theta = θ; Xi = Ξ; xi = ξ"
  end

  def create
    function = Conversion.new(rectangular: params[:conversion][:rectangular])
    function.cylindrical = create_cylindrical(function.rectangular)
    function.spherical   = create_spherical(function.rectangular)
    if function.save
      flash[:notice] = 'Conversion successful'
    else
      flash[:alert] = 'Couldnt convert for some reason'
    end
    redirect_to new_conversions_path
  end

  def destroy
    @function = Conversion.find(params[:id])
    @function.delete
    flash[:notice] = 'Successfully deleted Conversion'
    redirect_to new_conversions_path
  end

  private

  def create_cylindrical(function)
    lett = function.split('')
    ans  = ''
    lett.each{|l|
      l == 'x' ? ans.concat('rcos(θ)') : ans.concat(l)
    }
    lett = ans.split('')

    ans  = ''
    lett.each{|l|
      l == 'y' ? ans.concat('rsin(θ)') : ans.concat(l)
    }
    ans
  end

  def create_spherical(function)
    lett = function.split('')
    ans  = ''
    lett.each{|l|
      l == 'x' ? ans.concat('ρsin(φ)cos(θ)') : ans.concat(l)
    }

    lett = ans.split('')
    ans  = ''
    lett.each{|l|
      l == 'y' ? ans.concat('ρsin(φ)sin(θ)') : ans.concat(l)
    }

    lett = ans.split('')
    ans  = ''
    lett.each{|l|
      l == 'z' ? ans.concat('ρcos(φ)') : ans.concat(l)
    }
    ans
  end

end
