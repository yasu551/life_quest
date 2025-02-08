class Challenge < ApplicationRecord
  APPLICABLE_SCOPE_NAMES = %w[performed unperformed active inactive].freeze

  belongs_to :source, polymorphic: true
  has_one :challenge_notification, dependent: :destroy

  delegate :user, to: :source

  validates :name, presence: true

  after_save if: -> { perform_at.present? && performed_at.blank? } do
    SaveChallengeNotificationJob.set(wait_until: perform_at).perform_later(challenge_id: id)
  end
  after_save if: -> { performed_at.present? } do
    challenge_notification&.destroy
  end

  scope :default_order, -> { order(Arel.sql("performed_at DESC NULLS LAST, perform_at ASC NULLS LAST, id DESC")) }
  scope :performed, -> { where.not(performed_at: nil) }
  scope :unperformed, -> { where(performed_at: nil) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :applied_scopes, ->(scope_chains) do
    AppliedScopesQuery.new(self, APPLICABLE_SCOPE_NAMES).resolve(scope_chains)
  end

  def save_challenge_notification
    if challenge_notification&.persisted?
      challenge_notification.touch
    else
      create_challenge_notification
    end

    push_subscription = user.latest_push_subscription
    if push_subscription.present?
      path = Rails.application.routes.url_helpers.polymorphic_url([ source, self ], action: :edit, only_path: true)
      WebPushJob.perform_later(push_subscription_id: push_subscription.id, title: "「#{name}」をする時間です", body: description, path:)
    end
  end
end
