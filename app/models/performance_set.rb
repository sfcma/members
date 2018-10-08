class PerformanceSet < ApplicationRecord
  audited associated_with: :ensemble
  acts_as_paranoid
  has_many :member_sets
  has_many :performance_set_dates, inverse_of: :performance_set
  has_many :performance_set_instruments

  accepts_nested_attributes_for :performance_set_dates,
    :reject_if => proc { |att| att[:date].blank? }
  accepts_nested_attributes_for :performance_set_instruments,
    :reject_if => proc { |att| att[:instrument].blank? }

  # This maybe should be a has_and_belongs_to_many association
  has_many :members, through: :member_sets
  belongs_to :ensemble
  validates :ensemble_id, presence: true
  validates :name, presence: true, format: { with: /.*[0-9]{4}.*/,
                                             message: 'invalid -- must include a year' }
  validates_date :start_date, on_or_before: 5.years.from_now
  validates_date :end_date, on_or_before: 5.years.from_now

  scope :now_or_future, -> { where("end_date > ?", 1.week.ago.strftime('%F'))}
  scope :joinable, -> { where("opt_in_start_date < ? and opt_in_end_date > ?",
                              Time.now.strftime('%F'),
                              Time.now.strftime('%F'))}

  scope :emailable, -> { where("end_date > ? and start_date < ?",
                              4.weeks.ago.strftime('%F'),
                              6.weeks.from_now.strftime('%F'))}

  def old_name
    "#{Ensemble.find(ensemble_id).name} from #{start_date} to #{end_date}"
  end

  def extended_name
    description.present? ? "#{name} – #{description}" : name
  end

  def to_s
    return name
  end
end
