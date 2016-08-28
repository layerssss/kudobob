# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class DojoChannel < ApplicationCable::Channel
  def subscribed
    dojo = Dojo.find(params[:id])
    stream_for dojo
  end

  def unsubscribed
    puts 'unsubscribed'
  end
end
