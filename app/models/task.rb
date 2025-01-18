class Task < ApplicationRecord
  extend Enumerize

  paginates_per 10

  enumerize :status, in: %i[new waiting working completed pending], scope: true

  belongs_to :user
  has_many :time_entries, dependent: :restrict_with_exception
  has_many :activities, dependent: :restrict_with_exception
  has_many :task_taggings, dependent: :destroy
  has_many :tags, through: :task_taggings

  validates :name, presence: true
  validates :deadline_on, date: { allow_blank: true }
  validates :perform_on, date: { allow_blank: true }

  scope :default_order, -> { order(Arel.sql("deadline_on ASC NULLS LAST, perform_on ASC NULLS LAST, id DESC")) }
  scope :scheduled_on, ->(date) { where(perform_on: date) }
  scope :tagged_with, ->(tag) { where(id: TaskTagging.where(tag:).select(:task_id)) }

  def destroyable?
    !time_entries.exists? && !activities.exists?
  end
end
