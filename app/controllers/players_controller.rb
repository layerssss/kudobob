class PlayersController < ApplicationController

  private
  def player_params
    params.require(:player).permit(:dojo_id)
  end
end
