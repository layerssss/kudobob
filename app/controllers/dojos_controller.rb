class DojosController < ApplicationController
  def index
    @dojos = Dojo.all
  end
  before_action except: [:index, :new, :create] do
    @dojo = Dojo.find(params[:id])
  end

  private

  def dojo_params
    params.require(:dojo).permit(:width, :height)
  end
end
