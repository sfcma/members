class PerformanceSetInstrument < ApplicationRecord
  belongs_to :performance_set

  validates :instrument, presence: true
end
