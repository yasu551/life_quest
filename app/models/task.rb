class Task < ApplicationRecord
  extend Enumerize

  enumerize :status, in: %i[new waiting working completed pending], scope: true

  belongs_to :user
  has_many :time_entries, dependent: :restrict_with_exception
  has_many :activities, dependent: :restrict_with_exception
  has_many :task_taggings, dependent: :destroy
  has_many :tags, through: :task_taggings

  validates :name, presence: true
  validates :deadline_on, date: { allow_blank: true }

  scope :default_order, -> { order(id: :desc) }

  def destroyable?
    !time_entries.exists? && !activities.exists?
  end
end
