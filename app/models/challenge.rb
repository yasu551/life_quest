class Challenge < ApplicationRecord
  include Notifiable

  APPLICABLE_SCOPE_NAMES = %w[performed unperformed active inactive].freeze

  belongs_to :source, polymorphic: true

  delegate :user, to: :source

  validates :name, presence: true

  scope :default_order, -> { order(Arel.sql("performed_at DESC NULLS LAST, perform_at ASC NULLS LAST, id DESC")) }
  scope :performed, -> { where.not(performed_at: nil) }
  scope :unperformed, -> { where(performed_at: nil) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :applied_scopes, ->(scope_chains) do
    AppliedScopesQuery.new(self, APPLICABLE_SCOPE_NAMES).resolve(scope_chains)
  end

  private

  def push_subscription
    user.latest_push_subscription
  end

  def notified_content
    {
      title: "「#{name}」をする時間です",
      body: description,
      path: Rails.application.routes.url_helpers.polymorphic_url([ source, self ], action: :edit, only_path: true)
    }
  end
end
