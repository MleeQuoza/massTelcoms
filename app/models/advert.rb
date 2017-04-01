class Advert < ActiveRecord::Base
  enum status: { requested: 1, published: 2, rejected: 3 }

  def requested?
    Advert.statuses[self.status] == Advert.statuses[:requested]
  end
end