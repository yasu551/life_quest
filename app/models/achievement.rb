class Achievement < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Achievement", optional: true
  has_many :children, class_name: "Achievement", foreign_key: :parent_id, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :achieved_on, date: { allow_blank: true }

  scope :default_order, -> { order(id: :desc) }
  scope :ideal, -> { where(parent: nil) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :achieved, -> { where.not(achieved_on: nil) }
  scope :not_achieved, -> { where(achieved_on: nil) }
  scope :parents, -> { where(id: select(:parent_id)) }
  scope :terminal, -> { where.not(id: parents) }
  scope :feasible, -> do
    not_achieved
      .where(id: achieved.parents)
      .or(not_achieved.terminal)
  end
  scope :applied_scopes, ->(scope_chains) do
    valid_scope_names = %w[ ideal active inactive achieved not_achieved parents terminal feasible ]
    scope_names = scope_chains.split(".")
    scope_names.each do |scope_name|
      raise ArgumentError, "#{scope_name} is invalid" unless valid_scope_names.include?(scope_name)
    end

    scope_names.each_with_object(all) { |scope_name, records| records.public_send(scope_name) }
  end
end
