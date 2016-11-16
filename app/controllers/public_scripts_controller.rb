class PublicScriptsController < ApplicationController
  before_action :authenticate_user!, only: [:copy]
  before_action except: [:index, :new, :create] do
    @public_script = Script.where(public: true).find(params[:id])
  end

 def index
   @public_scripts = Script.where(public: true)
 end 

 def show
 end
 
 def copy
   current_user.scripts.create!(
     title: "Copy of #{@public_script.title.inspect} from #{@public_script.user.name.inspect}",
     content: @public_script.content
   )
   redirect_to scripts_path, notice: 'Copied!'
 end
end
