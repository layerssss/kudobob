# == Schema Information
#
# Table name: scripts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  public     :boolean
#  title      :string
#

class Script < ApplicationRecord
  belongs_to :user, inverse_of: :scripts
end
