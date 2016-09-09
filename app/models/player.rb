# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  dojo_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  keg        :string
#  position   :string
#  direction  :integer
#  ammo       :integer          default(0)
#

class Player < ApplicationRecord
  belongs_to :dojo, inverse_of: :players
  serialize :position
  after_initialize do
    self.position ||= [
      Random.rand(dojo.width),
      Random.rand(dojo.height)
    ]
    self.direction ||= Random.rand 4
  end

  def name
    "Player##{id} (#{position[0]} #{position[1]})"
  end

  def available_actions
    ['move', 'shoot', *direction_strings]
  end

  def perform!
    action = get_action
    puts "#{name} trying to perform #{action.inspect}"
    if action == 'shoot'
      raise "Can't shoot without ammo!" unless ammo > 0
      ammo -= 1
    elsif direction_strings.include?(action)
      self.update_attributes! direction: action
    elsif action == 'move'
      raise "Can't move against the wall!" unless dojo.position_valid?(next_position)
      self.update_attributes! position: next_position
    else
      raise "Unrecognised: #{action}"
    end
    puts "#{name} performed: #{action.inspect}"
  end

  def next_position(for_direction = nil)
    for_direction ||= direction
    x, y = position
    if for_direction % 2
      y += for_direction - 2
    else
      x += for_direction - 1
    end
    [x, y]
  end

  def direction_string
    direction_strings[direction]
  end

  def direction_strings
    %w(right up left down)
  end

  def get_action
    [*available_actions, *(2.times.map{ 'move' })].sample
  end

  def as_json(options)
    super(options).merge name: name
  end
end
