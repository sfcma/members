class MemberSet < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid

  has_many :set_member_instruments, dependent: :destroy
  has_many :member_instruments, through: :set_member_instruments
  belongs_to :member
  belongs_to :performance_set, class_name: 'PerformanceSet'
  accepts_nested_attributes_for :set_member_instruments, allow_destroy: true
  validates :performance_set, presence: true

  enum statuses: [:interested,
                  :performing,
                  :rehearsing,
                  :stopped_by_self,
                  :stopped_by_us,
                  :substituting,
                  :uninterested]

  def self.set_status_array
    ["Interested in playing this set",
    "Committed to perfoming in this set",
    "Attending rehearsals this set, not yet committed to concert",
    "Chose to stop playing this set",
    "Was asked to stop playing this set",
    "Subbing in rehearsals this set; not playing the concert",
    "Not interested in playing this set"]
  end

  def self.set_status_text(set_status)
    if set_status == 'interested'
      "Interested in playing this set"
    elsif set_status == 'performing'
      "Committed to perfoming in this set"
    elsif set_status == 'rehearsing'
      "Attending rehearsals this set, not yet committed to concert"
    elsif set_status == 'stopped_by_self'
      "Chose to stop playing this set"
    elsif set_status == 'stopped_by_us'
      "Was asked to stop playing this set"
    elsif set_status == 'substituting'
      "Subbing in rehearsals this set; not playing the concert"
    elsif set_status == 'uninterested'
      "Not interested in playing this set"
    else
      "Invalid Status"
    end
  end

  def self.email_status_to_status(email_status_id)
    case email_status_id.to_i
    when 0    # playing only
      [:performing, :rehearsing]
    when 1    # playing or opt in
      [:performing, :rehearsing, :interested]
    when 2    # any that are or might be playing
      [:performing, :rehearsing, :interested, :substituting]
    when 3    # any at all
      statuses.keys.map(&:to_s)
    when 4    # temporary, used for opt-in limit checking plz remove
      [:performing, :rehearsing, :interested]
    else
      throw 'Unexpected email status id'
    end
  end

  def self.filtered_by_criteria(performance_set_id, status_id, instruments = [])
    throw "Instruments must be an array, passed in #{instruments}" unless instruments.is_a?(Array)
    if instruments.length.zero?
      statuses = MemberSet.email_status_to_status(status_id)
      MemberSet.where(performance_set_id: performance_set_id, set_status: statuses)
    else
      use_variant_instruments = false
      if (instruments.include?('violin 1') || instruments.include?('violin 2')) && !instruments.include?('violin')
        use_variant_instruments = true
      end
      statuses = MemberSet.email_status_to_status(status_id)
      potential_members = Member.in_set_with_status(performance_set_id, statuses).compact
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
