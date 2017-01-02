class PerformanceSet < ApplicationRecord
  audited associated_with: :ensemble
  acts_as_paranoid
  has_many :member_sets
  has_many :performance_set_dates

  # This maybe should be a has_and_belongs_to_many association
  has_many :members, through: :member_sets
  belongs_to :ensemble
  validates :ensemble_id, presence: true
  validates :name, presence: true, format: { with: /.*[0-9]{4}.*/,
                                             message: 'invalid -- must include a year' }
  validates_date :start_date, on_or_before: 5.years.from_now
  validates_date :end_date, on_or_before: 5.years.from_now

  def old_name
    "#{Ensemble.find(ensemble_id).name} from #{start_date} to #{end_date}"
  end

  def to_s
    return name
  end
end
