module MembersHelper
  def setup_member_instruments(member)
    member.member_instruments.build if member.member_instruments.blank? || !member.member_instruments.map(&:new_record?).any?
    member
  end

  def select_current_member_instruments(member_set)
    return nil unless member_set && member_set.member && member_set.member.id
    if SetMemberInstrument.where(member_set_id: member_set.id).first
      SetMemberInstrument.where(member_set_id: member_set.id).first.instrument_name_with_variant
    end
  end

  def can_view_member_personal_info(member)
    member_performance_sets = member.member_sets.map(&:performance_set)
    current_user.global_admin? ||
    (
      (
        current_user.ensembles.map(&:ensemble_id) & member_performance_sets.compact.map(&:ensemble_id)
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

  def who_can_view_member(member)
    User.all.to_a.select do |u|
      if can_view_member_personal_info(member)
        member
      end
    end
  end
end
