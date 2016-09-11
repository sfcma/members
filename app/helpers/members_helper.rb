module MembersHelper

  def setup_member_instruments(member)
    member.member_instruments.build if member.member_instruments.blank? || !member.member_instruments.map(&:new_record?).any?
    member
  end

end
