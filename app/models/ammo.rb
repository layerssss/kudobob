# == Schema Information
#
# Table name: ammos
#
#  id         :integer          not null, primary key
#  position   :string
#  dojo_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Ammo < ApplicationRecord
  belongs_to :dojo, inverse_of: :ammos
  serialize :position
  before_save do
    self.position ||= [
      Random.rand(dojo.width),
      Random.rand(dojo.height)
    ]
  end
end
