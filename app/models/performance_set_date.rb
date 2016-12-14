class PerformanceSetDate < ApplicationRecord
  belongs_to :performance_set
  has_many :absences
end
