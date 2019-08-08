module Challenges; class ReportsController < AuthorizedController
  # GET /challenge
  def show
    @challenge = Challenge.new(challenge_payload)
  end

  private

  def challenge_payload
    @_challenge_payload ||= payload.transform_keys(&:to_sym).slice(*Challenge::Attributes)
  end

  def payload
    @_payload ||= {}
    # begin
    #   decoded_token = JWT.decode params[:token], nil, false
    #   decoded_token.first
    # end
  end

  def hired_return_url
    redirect_url = URI(Rails.configuration.hired['url'])
    redirect_url.path = '/assessments'
    redirect_url
  end

  def challenge_params
    params.fetch(:challenge, {}).permit(*Challenge::Attributes)
  end
end; end
