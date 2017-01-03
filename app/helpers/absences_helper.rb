module AbsencesHelper

  def absence_text(absence)
    text = ""
    if absence.planned
      text = link_to "Excused", absence_url(absence)
    else
      text = link_to "Unexcused", absence_url(absence)
    end

    if absence.sub_found
      text << "<br><i>SUB: #{absence.sub_found}<i>".html_safe
    end
    text
  end
end
