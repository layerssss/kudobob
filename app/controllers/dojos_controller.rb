class DojosController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create, :update, :edit, :destroy]
  before_action except: [:index, :new, :create] do
    @dojo = Dojo.find(params[:id])
  end

  def index
    @dojos = Dojo.all
  end

  def new
    @dojo = Dojo.new
    render 'edit'
  end

  def create
    @dojo = Dojo.new dojo_params
    if @dojo.save
      redirect_to @dojo, notice: 'Good start fighting!'
    else
      render 'edit'
    end
  end

  def show
    @scripts = Script.where(public: true).to_a
    @scripts.push *current_user.scripts if current_user
    @scripts.uniq!
  end

  def update
    @dojo.assign_attributes dojo_params
    if @dojo.save
      redirect_to dojos_path, notice: 'Done!'
    else
      render 'edit'
    end
  end

  def destroy
    @dojo.destroy!
    redirect_to dojos_path, notice: 'Done!'
  end

  private

  def dojo_params
    params.require(:dojo).permit(
      :title,
      :width,
      :height,
      :fast
    )
  end
end
