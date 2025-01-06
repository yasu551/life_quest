class Achievement < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Achievement", optional: true
  has_many :children, class_name: "Achievement", foreign_key: :parent_id, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :achieved_on, date: { allow_blank: true }
end
