# == Schema Information
#
# Table name: dojos
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  width      :integer          default(10)
#  height     :integer          default(10)
#

class Dojo < ApplicationRecord
  has_many :players, inverse_of: :dojo, dependent: :destroy
  has_many :ammos, inverse_of: :dojo, dependent: :destroy
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

  def perform!
    players.each do |player|
      begin
        player.perform!
      rescue RuntimeError => e
        puts e.message
      end
    end
    DojoChannel.broadcast_to(self, players: players)
  end

  def loop_perform!
    while true
      reload
      perform!
      sleep 0.5
    end
  end
end
