class AdvertsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  def create
    
  end
  
  
  private
  def adverts_params
    params.permit()
  end
end