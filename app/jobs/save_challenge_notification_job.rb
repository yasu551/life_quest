class SaveChallengeNotificationJob < ApplicationJob
  queue_as :default

  def perform(challenge_id:)
    challenge = Challenge.find_by(id: challenge_id)
    return if challenge.blank?

    challenge.save_challenge_notification
  end
end
