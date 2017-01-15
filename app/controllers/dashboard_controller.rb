class DashboardController < ApplicationController
  before_action :authenticate_user!

  def user_donations
  end

  def admin_dash
  end
end
