class Task < ApplicationRecord
  extend Enumerize

  enumerize :status, in: %i[new waiting working completed pending], scope: true

  belongs_to :user
  has_many :time_entries, dependent: :restrict_with_exception
  has_many :activities, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :deadline_on, date: { allow_blank: true }

  scope :default_order, -> { order(id: :desc) }
end
