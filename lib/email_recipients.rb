module EmailRecipients
  include PerformanceSetsHelper

  def determine_email_type
    if performance_set_id
      # members who were attached to a particular performance set
      'performance_set'
    elsif ensemble_id
      # members who were attached to a performance set of an ensemble in the
      # last twelve months
      'ensemble'
    elsif all
      # members who were attached to a performance set of any ensemble in the
      # last twelve months
      'active_members'
    elsif chamber
      'chamber'
    else
      nil
    end
  end

  def get_recipients(instruments = '', performance_set_id = nil, ensemble_id = nil,
                     status_id = nil, all = false, chamber = false)
    instruments = '' if instrument == 'null'
    instruments = instruments.split(',')

    email_type = determine_email_type(performance_set_id, ensemble_id, all, chamber)

    if email_type == 'performance_set'
      member_sets = MemberSet.filtered_by_criteria(performance_set_id, status_id, instruments)
      instrument_groups = organize_members_by_instrument(member_sets)
      # respond_to do |format|
      #   format.json { render json: member_sets.to_json(include: [:set_member_instruments, member: {include: [:member_instruments] }]), status: :ok }
      # end
    elsif email_type == 'ensemble'
      performance_set_ids = PerformanceSet
        .where('end_date > ?', 1.year.ago.strftime('%F'))
        .where(ensemble_id: ensemble_id)
        .map(&:id)
      member_ids = Member.played_with_ensemble_last_year(ensemble_id)
      member_sets = MemberSet.includes(:set_member_instruments, member: [:member_instruments]).where(performance_set_id: performance_set_ids, member_id: member_ids)
      instrument_groups = organize_members_by_instrument(member_sets)
      # respond_to do |format|
      #   format.json { render json: member_sets.to_json(include: [:set_member_instruments, member: {include: [:member_instruments] }]), status: :ok }
      # end

    elsif email_type == 'chamber'
      performance_set_ids = PerformanceSet
        .where('end_date > ?', 1.year.ago.strftime('%F'))
        .map(&:id)
      performing_members = MemberSet.includes(member: [:member_instruments]).where('performance_set_id in (?) and member_id in (?)', performance_set_ids, Member.played_with_any_ensemble_last_year).map(&:member)
      recent_members = Member.joined_last_six_months
      all_to_email = (performing_members + recent_members).uniq
      if instruments.present?
        all_to_email = all_to_email.select { |member| member.member_instruments.any? { |mi| instruments.include?(mi.instrument) } }
      end

      # respond_to do |format|
      #   format.json { render json: all_to_email.to_json(include: [:member_instruments]), status: :ok }
      # end
    elsif email_type == 'active_members'
      performance_set_ids = PerformanceSet
        .where('end_date > ?', 1.year.ago.strftime('%F'))
        .map(&:id)
      member_sets = MemberSet.includes(:set_member_instruments, member: [:member_instruments]).where(performance_set_id: performance_set_ids, member_id: Member.played_with_any_ensemble_last_year)
      instrument_groups = organize_members_by_instrument(member_sets)
      # respond_to do |format|
      #   format.json { render json: member_sets.to_json(include: [:set_member_instruments, member: {include: [:member_instruments] }]), status: :ok }
      # end
    end
  end

end
