class MemberMailer < ApplicationMailer

  def standard_member_email(user, subject, body)
    @user = user
    @body = body
    mail(to: @user.email_1, from: 'membership@sfcivicsymphony.org', subject: subject, body: @body)
  end

end
