class PerformanceSet < ApplicationRecord
  has_many :member_sets
  belongs_to :ensemble
  validates :ensemble_id, presence: true

  def name
    return "#{Ensemble.find(ensemble_id).name} from #{start_date} to #{end_date}"
  end
end
