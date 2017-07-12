class MemberSet < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid

  has_many :set_member_instruments, dependent: :destroy
  belongs_to :member
  belongs_to :performance_set, class_name: 'PerformanceSet'
  accepts_nested_attributes_for :set_member_instruments, allow_destroy: true
  validates :performance_set, presence: true

  enum statuses: ['Interested in playing this set, unconfirmed',
                  :playing,
                  'Stopped playing, due to member\'s own decision',
                  'Unable to play, not due to Member\'s decision',
                  :subbing,
                  'Not Interested in this set',
                  'Opted in for this set']

  # TODO
  # :interested, :playing, :stopped, :prevented, :subbing, :uninterested, :optedin
  # then we can do MemberSet.playing, etc

  def self.email_status_to_status(email_status_id)
    case email_status_id.to_i
    when 0    # playing only
      ['Playing']
    when 1    # playing or opt in
      ['Opted in for this set', 'Playing']
    when 2    # any that are or might be playing
      ['Interested in playing this set, unconfirmed', 'Playing', 'Subbing', 'Opted in for this set']
    when 3    # any at all
      statuses.keys.map(&:to_s).map(&:capitalize)
    else
      throw 'Unexpected email status id'
    end
  end

  def self.filtered_by_criteria(performance_set_id, status_id, instruments = [])
    if instruments.length.zero?
      statuses = MemberSet.email_status_to_status(status_id)
      MemberSet.where(performance_set_id: performance_set_id, set_status: statuses)
    else
      use_variant_instruments = false
      if (instruments.include?('violin 1') || instruments.include?('violin 2')) && !instruments.include?('violin')
        use_variant_instruments = true
      end
      statuses = MemberSet.email_status_to_status(status_id)
      potential_members =
        Member
        .in_set_with_status(performance_set_id, statuses)
      potential_member_set_ids = potential_members.map(&:member_set_ids).flatten
      if use_variant_instruments
        actual_member_set_ids =
          SetMemberInstrument
          .includes(:member_instrument)
          .where(member_set_id: potential_member_set_ids)
          .where('variant in (?) OR member_instruments.instrument in (?)', instruments, instruments)
          .references(:member_instruments)
          .map(&:member_set_id)
      else
        actual_member_set_ids =
          SetMemberInstrument
          .includes(:member_instrument)
          .where(member_set_id: potential_member_set_ids)
          .where('member_instruments.instrument' => instruments)
          .references(:member_instruments)
          .map(&:member_set_id)
      end
      MemberSet.where(id: actual_member_set_ids)
    end
  end

  def self.all_sets_by_instrument(instruments)
    use_variant_instruments = false
    if (instruments.include?('violin 1') || instruments.include?('violin 2')) && !instruments.include?('violin')
      use_variant_instruments = true
    end
    if use_variant_instruments
      actual_member_set_ids =
        SetMemberInstrument
        .includes(:member_instrument)
        .where('variant in (?) OR member_instruments.instrument in (?)', instruments, instruments)
        .references(:member_instruments)
        .map(&:member_set_id)
    else
      actual_member_set_ids =
        SetMemberInstrument
        .includes(:member_instrument)
        .where('member_instruments.instrument' => instruments)
        .references(:member_instruments)
        .map(&:member_set_id)
    end
    MemberSet.where(id: actual_member_set_ids)
  end

end
