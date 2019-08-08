class ChallengesController < AuthorizedController
  # GET /challenge
  def new
    @challenge = Challenge.new(challenge_payload)

    render :edit
  end

  def create
    @challenge = Challenge.new(challenge_params)

    AttemptWebhookJob.perform_later(@challenge.to_json)

    redirect_to hired_return_url.to_s, status: :found
  end

  def edit
    @challenge = Challenge.new(challenge_payload)
  end

  private

  def challenge_payload
    @_challenge_payload ||= payload.transform_keys(&:to_sym).slice(*Challenge::Attributes)
  end

  def decoded_token
    JWT.decode params[:token], nil, false
  end

  def payload
    @_payload ||= decoded_token.first
  end

  def hired_return_url
    redirect_url = URI(Rails.configuration.hired['url'])
    redirect_url.path = '/assessments'
    redirect_url
  end

  def challenge_params
    params.fetch(:challenge, {}).permit(*Challenge::Attributes)
  end
end
