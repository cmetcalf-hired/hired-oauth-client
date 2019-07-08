class ChallengeSerializer < ActiveJob::Serializers::ObjectSerializer
  # Checks if an argument should be serialized by this serializer.
  def serialize?(argument)
    argument.is_a? Challenge
  end

  # Converts an object to a simpler representative using supported object types.
  # The recommended representative is a Hash with a specific key. Keys can be of basic types only.
  # You should call `super` to add the custom serializer type to the hash.
  def serialize(challenge)
    super(
      "monotonic_event_id": challenge.id || challenge.token,
      "datetime_completed": challenge.completed_at,
      "datetime_invited": challenge.invited_at,
      "datetime_started": challenge.started_at,
      "results_url": challenge.results_url,
      "score_card": challenge.score_card,
      "points": challenge.points || 0,
      "score": challenge.score || 0,
      "status": "needs_review",
      "time_taken_seconds": challenge.time_taken
    )
  end

  # Converts serialized value into a proper object.
  def deserialize(hash)
    Challenge.new(hash)
  end

  def webhook_json
  end
end
