class AttemptWebhookJob < ApplicationJob
  queue_as :default

  def perform(webhook_payload)
    Rails.logger.debug { webhook_payload }

    conn = Faraday.new(
      url: ENV.fetch('HIRED_URL'),
      ssl: { verify: false },
      request: {
        oauth: {
          consumer_key: ENV['HIRED_CLIENT_ID'],
          consumer_secret: ENV['HIRED_CLIENT_SECRET']
        }
      }
    )
    conn.use FaradayMiddleware::OAuth
    conn.patch("/api/webhooks/assessment-attempts/#{webhook_payload['monotonic_event_id']}", webhook_payload)
  end
end
