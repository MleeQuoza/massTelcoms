class AdvertsController < ApplicationController
  before_action :authenticate_user!
  def create
    
  end
  
  
  private
  def adverts_params
    params.permit()
  end
end