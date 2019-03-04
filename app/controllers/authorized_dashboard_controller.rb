class AuthorizedDashboardController < ApplicationController
  # GET /dashboard
  def show
    authenticate_user!
  end
end
