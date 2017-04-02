class WelcomeController < ApplicationController
  def home
    if current_user
      redirect_to  api_v1_dashboard_index_path
    end
  end
end
