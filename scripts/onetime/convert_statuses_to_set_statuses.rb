def convert_statuses
  MemberSet.all.each do |ms|
    case ms.set_status
    when 'Interested in playing this set, unconfirmed'
      ms.update(set_status_id: :interested)
    when 'playing'
      ms.update(set_status_id: :performing)
    when 'Stopped playing, due to member\'s own decision'
      ms.update(set_status_id: :stopped_by_self)
    when 'Unable to play, not due to Member\'s decision'
      ms.update(set_status_id: :stopped_by_us)
    when 'subbing'
      ms.update(set_status_id: :substituting)
    when 'Not Interested in this set'
      ms.update(set_status_id: :uninterested)
    when 'Opted in for this set'
      ms.update(set_status_id: :interested)
    end
  end
end
