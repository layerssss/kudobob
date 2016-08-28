# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class PlayerChannel < ApplicationCable::Channel
  def subscribed
    stream_for player
  end

  def heartbeat
    stream_for player
    player.touch
    Player.where('updated_at < ?', 2.seconds.ago).delete_all
  end

  def unsubscribed
  end

  private
  def player
    Player.find_or_create_by!(params.slice(:keg, :dojo_id))
  end
end
