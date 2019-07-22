class AttemptWebhookJob < ApplicationJob
  queue_as :default

  def perform(webhook_payload)
    Rails.logger.debug { webhook_payload }

    conn = Faraday.new(url: ENV.fetch('HIRED_URL'), ssl: { verify: false })
    conn.token_auth('authentication-token')
    conn.patch("/api/webhooks/assessment-attempts/#{webhook_payload['monotonic_event_id']}", webhook_payload)

    Rails.logger.info { 'did a thing' }


    # Do something later
  end
end
