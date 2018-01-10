class CommunityNight < ApplicationRecord
  audited
  acts_as_paranoid
  has_many :member_community_nights
  has_many :community_night_instruments
  has_many :members, through: :member_community_nights

  accepts_nested_attributes_for :community_night_instruments,
    :reject_if => proc { |att| att[:instrument].blank? }

  scope :joinable, -> { where("start_datetime > ? and start_datetime < ?",
                              3.hours.ago.strftime('%F'),
                              2.months.from_now.strftime('%F'))}
  scope :now_or_future, -> { where("end_datetime > ?", 1.week.ago.strftime('%F'))}

  def name_with_date
    "#{name} – #{start_datetime.strftime('%b %e %l:%M%P')}"
  end

end
