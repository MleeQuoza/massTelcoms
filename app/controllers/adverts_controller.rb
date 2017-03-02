class AdvertsController < ApplicationController
  def create
    
  end
  
  
  private
  def adverts_params
    params.permit()
  end
end