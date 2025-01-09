class User < ApplicationRecord
  PASSWORD_MIN_LENGTH = 8
  PASSWORD_MAX_LENGTH = 72

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :achievements, dependent: :restrict_with_exception
  has_many :achievement_challenges, through: :achievements, source: :challenges
  has_many :tasks, dependent: :restrict_with_exception
  has_many :activities, through: :tasks
  has_many :activity_summaries, dependent: :restrict_with_exception
  has_many :activity_challenges, through: :activities, source: :challenges
  has_many :tags, dependent: :restrict_with_exception

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :password, length: { in: PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH }
end
