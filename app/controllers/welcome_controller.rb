class WelcomeController < ApplicationController
  def home
    @adverts = Advert.where(status: Advert.statuses[:published])
    
    if current_user
      redirect_to dashboard_index_path
    end
  end
end
