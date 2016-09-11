class PerformanceSet < ApplicationRecord
  belongs_to :ensemble
  validates :ensemble_id, presence: true
end
