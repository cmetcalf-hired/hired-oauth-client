class AttemptWebhookJob < ApplicationJob
  queue_as :default

  def perform(challenge_params)
    Rails.logger.debug { challenge_params }

    challenge = Challenge.new(challenge_params)
    conn = Faraday.new(url: ENV.fetch('HIRED_URL'), ssl: { verify: false })
    conn.token_auth('authentication-token')
    conn.patch("/api/webhooks/assessment-attempts/#{challenge.id}", challenge.webhook_json)

    Rails.logger.info { 'did a thing' }


    # Do something later
  end
end
