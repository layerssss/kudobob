# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class PlayerChannel < ApplicationCable::Channel
  def subscribed
    player.update_attributes! name: params[:name]
    stream_for player
  end

  def heartbeat
    player.update_attributes! name: params[:name]
    dojo.players.where('players.updated_at < ?', 10.seconds.ago).each(&:destroy!)
    dojo.next_player! if dojo.active_player.nil? || dojo.active_player_expired?
  end

  def rename(data)
    player.update_attributes!(name: data.fetch('new_name'))
  end

  def ai_action(data)
    action = data.fetch('ai_action')
    dojo.player_perform!(player, action)
  end

  def unsubscribed
    player.destroy!
  end

  private
  def player
    dojo.players.find_or_create_by!(keg: params[:keg], user: current_user)
  end

  def dojo
    Dojo.find(params[:dojo_id])
  end
end
