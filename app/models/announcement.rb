# == Schema Information
#
# Table name: announcements
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Announcement < ApplicationRecord
end
