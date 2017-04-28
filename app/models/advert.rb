# == Schema Information
#
# Table name: adverts
#
#  id          :integer          not null, primary key
#  title       :text
#  image_url   :text
#  advert_body :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default("requested"), not null
#  user_id     :integer          not null
#  phone       :text
#  email       :text
#  address     :text
#

class Advert < ApplicationRecord
  enum status: { requested: 1, published: 2, rejected: 3 }

  def requested?
    Advert.statuses[self.status] == Advert.statuses[:requested]
  end
end
