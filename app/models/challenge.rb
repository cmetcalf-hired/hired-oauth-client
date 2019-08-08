class Challenge
  include ActiveModel::Model

  Attributes = %i{id completed_at invited_at points results_url score score_card started_at
    time_taken token url}

  attr_accessor *Attributes

  def to_json
    <<~JSON.squish
    {
      "monotonic_event_id": "#{id || token}",
      "datetime_completed": "#{completed_at}",
      "datetime_invited": "#{invited_at}",
      "datetime_started": "#{started_at}",
      "results_url": "#{results_url}",
      "score_card": {#{score_card_json}
        "points": #{points || 0},
        "score": #{score || 0}
      },
      "status": "#{status}",
      "time_taken_seconds": #{time_taken}
    }
    JSON
  end

  def status
    case
    when completed_at.present?
      'needs_review'
    when started_at.present?
      'started'
    when invited_at.present?
      'invited'
    end
  end

  def score_card
    @score_card ||= {}
  end

  def score_card_json
    return '' if score_card.empty?

    <<~JSON.squish
      \n#{JSON.generate(score_card)},
    JSON
  end

  def score
    @score ||= 0
  end

  def points
    @points ||= 0
  end

  def sample_score_card
    <<~JSON.squish
    {
      "coding": {
        "points": 250,
        "questions": [{
            "points": 50,
            "score": 0,
            "template_id": 57,
            "time_taken": 4.887827157974243
          },
          {
            "points": 50,
            "score": 0,
            "template_id": 58,
            "time_taken": 0
          },
          {
            "points": 50,
            "score": 0,
            "template_id": 59,
            "time_taken": 0
          },
          {
            "points": 50,
            "score": 0,
            "template_id": 60,
            "time_taken": 0
          },
          {
            "points": 50,
            "score": 0,
            "template_id": 61,
            "time_taken": 0
          }
        ],
        "score": 0
      },
      "multiple_choice": {
        "points": 40,
        "questions": [{
            "points": 10,
            "score": 0,
            "template_id": 86
          },
          {
            "points": 10,
            "score": 0,
            "template_id": 82
          },
          {
            "points": 10,
            "score": 0,
            "template_id": 92
          },
          {
            "points": 10,
            "score": 0,
            "template_id": 94
          }
        ],
        "score": 0
      }
    }
    JSON
  end
end
