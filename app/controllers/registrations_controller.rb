class RegistrationsController < Devise::RegistrationsController
  
  def create
    super do |resource|
      resource.referer_guid = params[:ref]
    end
  end
end