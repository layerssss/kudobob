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
#  ammo_count :integer          default(0)
#  alive      :boolean          default(TRUE)
#  user_id    :integer
#  color      :string
#  name       :string
#  died_at    :datetime
#

class Player < ApplicationRecord
  belongs_to :dojo, inverse_of: :players
  belongs_to :user, inverse_of: :players
  serialize :position

  scope :alive, -> { where alive: true }
  scope :dead, -> { where alive: false }

  default_scope -> { order id: :asc }

  before_destroy do
    dojo.next_player! if dojo.active_player_id == id
  end

  after_initialize do
    self.color ||= "##{color_generator.create_hex}"
    self.position ||= [
      Random.rand(dojo.width),
      Random.rand(dojo.height)
    ]
    self.direction ||= Random.rand 4
  end

  after_create do
    dojo.next_player! if dojo.active_player.nil?
  end

  def name
    super || "Player##{id}"
  end

  def title
    "#{name}#{" (#{user})" if user}"
  end

  def to_s
    title
  end

  def available_actions
    ['move', 'shoot', *direction_strings]
  end

  def perform!(action)
    # TODO: refactor this into seperate methods
    # TODO: abstract geometry objects
    puts "#{name} trying to perform #{action.inspect}"
    if action == 'shoot'
      raise "Can't shoot without ammo!" unless ammo_count > 0
      dojo.players.each do |enemy|
        hit = false
        case direction_string
        when 'right'
          hit = enemy.position[1] == position[1] && enemy.position[0] > position[0]
        when 'left'
          hit = enemy.position[1] == position[1] && enemy.position[0] < position[0]
        when 'down'
          hit = enemy.position[0] == position[0] && enemy.position[1] > position[1]
        when 'up'
          hit = enemy.position[0] == position[0] && enemy.position[1] < position[1]
        end
        next unless hit
        enemy.update_attributes! alive: false, died_at: Time.current
      end
      DojoChannel.broadcast_to(
        dojo,
        fire: {
          position: position,
          direction: direction
        }
      )
      update_attributes!(
        ammo_count: ammo_count - 1
      )
    elsif direction_strings.include?(action)
      update_attributes! direction: direction_strings.index(action)
    elsif action == 'move'
      raise "Can't move against the wall!" unless dojo.position_valid? next_position
      getting_ammos = dojo.ammos.select { |ammo| ammo.position == next_position }
      update_attributes!(
        position: next_position,
        ammo_count: ammo_count + getting_ammos.size
      )
      getting_ammos.each(&:destroy!)
    elsif action.present?
      raise "Unrecognised: #{action.inspect}"
    end
    puts "#{name} performed: #{action.inspect}"
  end

  def next_position(for_direction = nil)
    for_direction ||= direction
    x, y = position
    if for_direction % 2 > 0
      y += for_direction - 2
    else
      x -= for_direction - 1
    end
    [x, y]
  end

  def direction_string
    direction_strings[direction]
  end

  def direction_strings
    %w(right up left down)
  end

  def as_json(options)
    super(options).merge(
      title: title,
      available_actions: available_actions
    )
  end

  private

  def color_generator
    @@color_generator ||= ColorGenerator.new(
      saturation: 0.99,
      lightness: 0.7,
      seed: 1
    )
  end
end
