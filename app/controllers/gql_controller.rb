class GqlController < ActionController::API
  before_action :authenticate_user!

  def mutate
  end
end
