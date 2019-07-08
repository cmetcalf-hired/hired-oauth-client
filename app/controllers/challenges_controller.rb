class ChallengesController < AuthorizedController
  # GET /challenge
  def new
    @challenge = Challenge.new(params.permit(:token))
  end

  def create
    @challenge = Challenge.new(challenge_params)

    AttemptWebhookJob.perform_later(current_user, challenge)

    redirect_to hired_return_url.to_s, status: :found
  end

  private

  def hired_return_url
    redirect_url = URI(ENV.fetch('HIRED_URL'))
    redirect_url.path = '/assessments'
    redirect_url
  end

  def challenge_params
    params.fetch(:challenge, {}).permit(*Challenge::Attributes)
  end
end
