class Challenge < ApplicationRecord
  APPLICABLE_SCOPE_NAMES = %w[performed unperformed active inactive].freeze

  belongs_to :source, polymorphic: true

  validates :name, presence: true

  scope :default_order, -> { order(id: :desc) }
  scope :performed, -> { where.not(performed_at: nil) }
  scope :unperformed, -> { where(performed_at: nil) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :applied_scopes, ->(scope_chains) do
    AppliedScopesQuery.new(self, APPLICABLE_SCOPE_NAMES).resolve(scope_chains)
  end
end
