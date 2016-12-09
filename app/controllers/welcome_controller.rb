class WelcomeController < ApplicationController
  def home
    if current_user
      redirect_to dashboard_index_path
    end
  end
end
