class Api::V1::AnnouncementsController < Api::V1::BaseController
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
  
  def destroy
    authorize! :create, Announcement
    
    announcement = Announcement.find(params[:id])
    if announcement.destroy!
      redirect_to announcements_path, notice: 'Record Deleted'
    else
      redirect_to announcements_path, notice: 'Deletion failed'
    end
  end
  
  private
  
  def announcement_params
    params.permit(:content)
  end
end