class DashboardController < ApplicationController

  # GET /dashboard
  def show
    redirect_to new_user_session_path
  end
end
