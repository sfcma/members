module MembersHelper
  def setup_member_instruments(member)
    member.member_instruments.build if member.member_instruments.blank? || !member.member_instruments.map(&:new_record?).any?
    member
  end

  def select_current_member_instruments(member_set)
    return nil unless member_set && member_set.member && member_set.member.id
    if SetMemberInstrument.where(member_set_id: member_set.id).first
      return MemberInstrument.find(SetMemberInstrument.where(member_set_id: member_set.id).first.member_instrument_id).instrument
    end
  end

  def can_view_member_personal_info(member)
    current_user.global_admin? ||
    (
      (
        current_user.ensembles.map(&:ensemble_id) & member.member_sets.map(&:performance_set).map(&:ensemble_id)
      ).present? &&
      (
        (
          current_user.instruments.map(&:instrument) & member.member_instruments.map(&:instrument)
        ).present? ||
        current_user.instruments.include?('all')
      )
    )
  end

  def can_view_member_email(member)
    current_user.global_admin? ||
    ( current_user.instruments.map(&:instrument) & member.member_instruments.map(&:instrument) )
  end
end
