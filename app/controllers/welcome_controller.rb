class WelcomeController < ApplicationController
  
  def how_to
    render 'welcome/how_to'
  end
  
  def terms
    render 'welcome/terms'
  end
end
