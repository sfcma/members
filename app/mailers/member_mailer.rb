class MemberMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def standard_member_email(member, subject, body, sending_user, email_id, member_id, perf_set_name, inst, status, set_member_instrument)
    @body = simple_format(body)
    @subject = subject
    @sending_user = sending_user
    @member_id = member_id
    @email_id = email_id
    @perf_set_name = perf_set_name
    @instruments = inst.gsub(/[\"\]\[]/,"").split(",").reject!(&:blank?) || []
    @instruments = @instruments.map(&:strip)
    if status == 0
      @status_text = "are playing in"
    elsif status == 1
      @status_text = "are playing in or opted into"
    else
      @status_text = "are playing in or attending rehearsals for"
    end
    if @instruments.present?
      @instrument = set_member_instrument.first.member_instrument.instrument
    else
      @instrument = ""
    end

    mail(to: "#{member.to_s} <#{member.email_1}>",
          reply_to: "#{sending_user.name} <#{sending_user.email}>",
          from: 'Civic Symphony Association of San Francisco <no-reply@mail.sfcivicmusic.org>',
          subject: subject)
  end

end
