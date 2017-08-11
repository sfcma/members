class PerformanceSetInstrument < ApplicationRecord
  belongs_to :performance_set
  before_save { |psi| psi.instrument = psi.instrument.underscore }

  validates :instrument, presence: true
end
