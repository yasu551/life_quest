class Activity < ApplicationRecord
  include Notifiable

  APPLICABLE_SCOPE_NAMES = %w[scheduled performed good neutral bad].freeze

  belongs_to :user
  belongs_to :task, optional: true
  has_one :activity_evaluation, dependent: :destroy
  accepts_nested_attributes_for :activity_evaluation
  has_many :challenges, as: :source, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :perform_at, presence: true

  scope :default_order, -> { order(Arel.sql("performed_at DESC NULLS LAST, perform_at ASC NULLS LAST, id DESC")) }
  scope :scheduled, -> { where(performed_at: nil).where.not(perform_at: nil) }
  scope :performed, -> { where.not(performed_at: nil) }
  scope :perform_on, ->(date) { where(perform_at: date.all_day) }
  scope :performed_on, ->(date) { where(performed_at: date.all_day) }
  scope :by_evaluation_value, ->(value) do
    raise ArgumentError, "Invalid value: #{value}" unless ActivityEvaluation::VALUES.include?(value.to_sym)

    joins(:activity_evaluation).where(activity_evaluation: { value: })
  end
  scope :good, -> { by_evaluation_value(:good) }
  scope :neutral, -> { by_evaluation_value(:neutral) }
  scope :bad, -> { by_evaluation_value(:bad) }
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
      path: Rails.application.routes.url_helpers.edit_activity_path(self)
    }
  end
end
