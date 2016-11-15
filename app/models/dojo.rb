# == Schema Information
#
# Table name: dojos
#
#  id                       :integer          not null, primary key
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  width                    :integer          default(10)
#  height                   :integer          default(10)
#  active_player_id         :integer
#  active_player_updated_at :datetime
#  fast                     :boolean          default(FALSE)
#

class Dojo < ApplicationRecord
  has_many :players, inverse_of: :dojo, dependent: :destroy
  has_many :ammos, inverse_of: :dojo, dependent: :destroy
  belongs_to :active_player, class_name: 'Player', foreign_key: :active_player_id

  def title
    "Dojo ##{id}"
  end

  def to_s
    title
  end

  def max_x
    width - 1
  end

  def max_y
    height - 1
  end

  def position_valid?(position)
    x, y = position
    (0..max_x).cover?(x) && (0..max_y).cover?(y)
  end

  def player_perform!(player, action)
    begin
      raise "Too slow! Not your turn..." unless player.id == active_player_id
      player.perform! action
    rescue RuntimeError => e
      puts e.message
      PlayerChannel.broadcast_to(player, error: e.message)
    end
    players.dead.each do |player|
      next if player.died_at > 10.seconds.ago
      player.update_attributes!(alive: true)
    end
    DojoChannel.broadcast_to(
      self,
      dojo: self,
      players: players,
      ammos: ammos,
    )
    if players.alive.any?
      sleep 1.0 / players.alive.count
    end
    next_player!
  end

  def active_player_expired?
    active_player_updated_at && active_player_updated_at < 5.seconds.ago
  end

  def next_player!
    reload
    new_active_player = nil
    if active_player.nil? || !active_player.alive
      new_active_player = players.alive.first
    else
      index = players.alive.find_index(active_player)
      new_active_player =  players.alive[(index + 1) % players.alive.size]
    end
    update_attributes! active_player: new_active_player, active_player_updated_at: Time.current
    # TODO: refactor that
    ammos.create! unless ammos.size > width * height * 0.1
    if new_active_player
      PlayerChannel.broadcast_to(
        new_active_player,
        step: {
          dojo: self,
          player: new_active_player,
          enemies: players.alive.reject{ |p| p.id == new_active_player.id },
          ammos: ammos,
        }
      )
    end
    new_active_player
  end
end
