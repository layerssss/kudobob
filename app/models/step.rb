# == Schema Information
#
# Table name: steps
#
#  id         :integer          not null, primary key
#  player_id  :integer
#  index_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Step < ApplicationRecord
end
