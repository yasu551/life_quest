class Activity < ApplicationRecord
  belongs_to :task
  has_one :activity_evaluation, dependent: :destroy
  accepts_nested_attributes_for :activity_evaluation
  has_many :challenges, as: :source, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :performed_at, presence: true

  scope :default_order, -> { order(performed_at: :desc, id: :desc) }
  scope :by_evaluation_value, ->(value) do
    raise ArgumentError, "Invalid value: #{value}" unless ActivityEvaluation::VALUES.include?(value.to_sym)

    joins(:activity_evaluation).where(activity_evaluation: { value: })
  end
end
