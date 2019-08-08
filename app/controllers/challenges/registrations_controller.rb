module Challenges; class RegistrationsController < ActionController::API
  before_action :authenticate_user!

  def create
    render json: {
      data: {
        sendHiredChallenge: {
          link: challenge_link,
          pk: challenge_id
        }
      }
    }
  end

  private

  def challenge_id
    @_challenge_id ||= Time.current.to_i
  end

  def challenge_link
    Rails.logger.info { "\n\n\nROOT_URL: #{root_url}" }
    hired_assessment_url = URI(root_url)

    Rails.application.routes.url_helpers.challenge_url(challenge_id, host: hired_assessment_url.to_s, token: token)
  end

  # this is a different shape than the actual assessment token that is passed,
  # but we're gonna use it so that we don't have to keep anything in memory.
  def token
    JWT.encode jwt_payload, nil, 'none'
  end

  private

  def authenticate_user!
    unless request.env['HTTP_AUTHORIZATION'].match(/hiredinteraltestkey1234567890abcd/i)
      raise AuthorizationError
    end
  end

  def jwt_payload
    { id: challenge_id }.merge(params['variables'].permit!)
  end
end; end
