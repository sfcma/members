# TODO: Rename to "RehearsalDate"
class PerformanceSetDate < ApplicationRecord
  belongs_to :performance_set, required: true
  has_many :absences

  validates :date, presence: true
end
