class AnnouncementsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    render 'dashboard/announcement_center'
  end
  
  def create
    authorize! :create, Announcement
    
    announcement = Announcement.create(announcement_params)
    if announcement.save!
      redirect_to announcements_path
    else
      redirect_to announcements_path
    end
  end
  
  private
  
  def announcement_params
    params.permit(:content)
  end
end