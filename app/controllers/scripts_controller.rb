class ScriptsController < ApplicationController
  before_action :authenticate_user!
  before_action except: [:index, :all, :new, :create] do
    @script = current_user.scripts.find(params[:id])
  end

  def index
    @scripts = current_user.scripts
  end

  def new
    @script = current_user.scripts.new
    render 'edit'
  end

  def create
    @script = current_user.scripts.new script_params
    if @script.save
      redirect_to scripts_path, notice: 'Created!'
    else
      render 'edit'
    end
  end

  def update
    @script.assign_attributes script_params
    if @script.save
      redirect_to scripts_path, notice: 'Saved!'
    else
      render 'edit'
    end
  end

  def destroy
    @script.destroy!
    redirect_to scripts_path, notice: 'Destroy!'
  end

  def copy
    current_user.scripts.create!(
      title: "Copy of #{@script.title}",
      content: @script.content
    )
    redirect_to scripts_path, notice: 'Copied!'
  end

  private

  def script_params
    params.require(:script).permit(:title, :content, :public)
  end
end
