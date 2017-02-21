class WelcomeController < ApplicationController
  def home
    if current_user
      redirect_to dashboard_index_path
    end
  end
  
  def how_to
    render 'welcome/how_to'
  end
  
  def terms
    render 'welcome/terms'
  end
end
