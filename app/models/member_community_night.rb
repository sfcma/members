class MemberCommunityNight < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid

  belongs_to :member_instrument

  belongs_to :member
  belongs_to :community_night
  validates :community_night, presence: true

  def self.get_count(community_night_id, instruments = [])
    throw "Instruments must be an array, passed in #{instruments}" unless instruments.is_a?(Array)
    if instruments.length.zero?
      MemberSet.where(community_night_id: community_night_id)
    else
      use_variant_instruments = false
      if (instruments.include?('violin 1') || instruments.include?('violin 2')) && !instruments.include?('violin')
        use_variant_instruments = true
      end
      potential_members = MemberCommunityNight.where(community_night_id: community_night_id).map(&:member).compact
      potential_member_community_night_ids = potential_members.map(&:member_community_night_ids).flatten
      actual_member_community_night_ids =
        MemberCommunityNight
          .joins(:member_instrument)
          .where(id: potential_member_community_night_ids)
          .where('member_instruments.instrument' => instruments)
          .references(:member_instruments)
          .map(&:id)
      MemberCommunityNight.where(id: actual_member_community_night_ids)
    end
  end
end
