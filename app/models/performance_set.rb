class PerformanceSet < ApplicationRecord
  audited
  has_many :member_sets
  belongs_to :ensemble
  validates :ensemble_id, presence: true
  validates :name, presence: true, format: { with: /.*[0-9]{4}.*/,
                                             message: "invalid -- must include a year"}
  validates_date :start_date, on_or_before: 5.years.from_now
  validates_date :end_date, on_or_before: 5.years.from_now

  def old_name
    return "#{Ensemble.find(ensemble_id).name} from #{start_date} to #{end_date}"
  end
end
