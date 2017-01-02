class MemberMailer < ApplicationMailer

  def standard_member_email(user, subject, body, current_user)
    @user = user
    @body = body
    @current_user = current_user
    mail(to: "#{user.first_name} #{user.last_name} <#{@user.email_1}>",
         from: 'Civic Symphony Association of San Francisco <no-reply@mail.sfcivicmusic.org>',
         subject: subject)
  end

end
