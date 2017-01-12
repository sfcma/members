module AbsencesHelper

  def absence_text(absence)
    text = ""
    if absence.planned
      text = link_to "Reported", absence_url(absence)
    else
      text = link_to "Unreported", absence_url(absence)
    end

    if absence.planned
      text << "<br><i style='color: gray; font-size: 0.9em;'>Submitted #{absence.created_at.strftime('%b %e %H:%M')}</i>".html_safe
    end

    if absence.sub_found.present?
      text << "<br><i>SUB: #{absence.sub_found}<i>".html_safe
    end
    text
  end

  def sort_by_set_instrument(member)
    @member_sets.where('member_id = ?', member.id).first.set_member_instruments.first.member_instrument.instrument
  end
end
