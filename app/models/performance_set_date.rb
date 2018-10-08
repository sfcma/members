# TODO: Rename to "RehearsalDate"
class PerformanceSetDate < ApplicationRecord
  belongs_to :performance_set, required: true, inverse_of: :performance_set_dates
  has_many :absences

  validates :date, presence: true
end
