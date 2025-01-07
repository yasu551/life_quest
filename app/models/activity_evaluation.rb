class ActivityEvaluation < ApplicationRecord
  extend Enumerize

  VALUES = %i[good neutral bad].freeze

  enumerize :value, in: VALUES

  belongs_to :activity
end
