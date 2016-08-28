# == Schema Information
#
# Table name: scripts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Script < ApplicationRecord
end
