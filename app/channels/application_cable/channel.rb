module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def current_user
      User.first
    end
  end
end
