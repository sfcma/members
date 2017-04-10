class MemberMailer < ApplicationMailer

  def standard_member_email(members, subject, body, sending_user)
    @body = body
    @subject = subject
    @sending_user = sending_user
    bcced_users = members.map{ |m| "#{m.to_s} <#{m.email_1}>"}.join(",")

    mail(to: 'Civic Symphony Association of San Francisco <no-reply@mail.sfcivicmusic.org>',
         bcc: bcced_users,
         reply_to: "#{sending_user.name} <#{sending_user.email}>",
         from: 'Civic Symphony Association of San Francisco <no-reply@mail.sfcivicmusic.org>',
         subject: subject)
  end

end
