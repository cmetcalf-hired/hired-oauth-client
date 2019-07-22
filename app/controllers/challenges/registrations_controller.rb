module Challenges; class RegistrationsController < ActionController::API
  before_action :authenticate_user!

  def create
    render json: {
      data: {
        sendHiredChallenge: {
          link: Rails.application.routes.url_helpers.challenge_url(challenge_id, host: root_url, token: token),
          pk: challenge_id
        }
      }
    }
  end

  private

  def challenge_id
    @_challenge_id ||= Time.current.to_i
  end

  # this is different than the actual token that is passed, but we're gonna use it so that we
  # don't have to keep anything in memory
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
