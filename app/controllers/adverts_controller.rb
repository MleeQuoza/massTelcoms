class AdvertsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update]
  
  def index
    if current_user && current_user.is?('admin')
      @adverts = Advert.all
      render 'adverts/admin_ads'
    elsif current_user && current_user.is?('user')
      render 'user_ads'
    end
    @adverts = Advert.where(status: Advert.statuses[:published])
  end
  
  def edit
    @advert = Advert.find(params[:id])
  end
  
  def update
    ad = Advert.find(params[:id])
    respond_to do |format|
      if ad.update!(advert_params)
        format.js { render inline: 'location.reload();' }
        format.html { redirect_to adverts_path }
      end
    end
  end
  
  def create
    ad = Advert.create(advert_params)
    respond_to do |format|
      if ad.save
        format.js { render inline: 'location.reload();' }
        format.html { redirect_to user_donations_path(user_id: current_user.id) }
      end
    end
  end
  
  def destroy
    ad = Advert.find(params[:id])
    ad.destroy!
    redirect_to adverts_path
  end
  
  def toggle_advert_status
    ad = Advert.find(params[:id])
    ad.update!(status: params[:status].to_i)
    redirect_to dashboard_admin_path
  end
  
  private

  def advert_params_js
    params.permit(:user_id, :title, :advert_body, :phone, :address, :email)
  end
  
  def advert_params
    params.require(:advert).permit(:user_id, :title, :advert_body, :phone, :address, :email, :status)
  end
end