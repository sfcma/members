class MemberMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def standard_member_email(member, subject, body, sending_user, email_id, member_id, perf_set_name, inst, status, set_member_instrument, ensemble_id)
    @body = simple_format(body)
    @subject = subject
    @sending_user = sending_user
    @member_id = member_id
    @email_id = email_id
    @perf_set_name = perf_set_name
    email = Email.find(@email_id)
    @behalf_name = email.behalf_of_name
    @behalf_email = email.behalf_of_email
    @sent_by_label = sending_user.name
    if (@behalf_name.present? && @behalf_email.present?)
      reply_to_user_name = @behalf_name
      reply_to_email = @behalf_email
      @sent_by_label = "#{sending_user.name} on behalf of #{reply_to_user_name}"
    else
      reply_to_user_name = sending_user.name
      reply_to_email = sending_user.email
    end
    @instruments = inst.gsub(/[\"\]\[]/,"").split(",").reject!(&:blank?) || []
    @instruments = @instruments.map(&:strip)
    if ensemble_id
      @status_text = "played in the ensemble #{Ensemble.find(ensemble_id).name} in the last year"
      @perf_set_name = ""
    elsif perf_set_name
      if status == 0
        @status_text = "are playing in"
      elsif status == 1
        @status_text = "are playing in or considering playing in"
      else
        @status_text = "are playing in or attending rehearsals for"
      end
    else
      @status_text = "participated in an SF Civic Music ensemble in the last year"
      @perf_set_name = ""
    end

    if @instruments.present?
      @instrument = set_member_instrument.first.member_instrument.instrument
    else
      @instrument = ""
    end

    email.attachments.each do |attachment|
      attachments[attachment.file_file_name] = { mime_type: attachment.file_content_type,
                                                   content: File.read(attachment.file.path) }
    end

    mail(to: "#{member.to_s} <#{member.email_1}>",
          reply_to: "#{reply_to_user_name} <#{reply_to_email}>",
          from: "#{reply_to_user_name} via SF Civic Music <no-reply@mail.sfcivicmusic.org>",
          subject: subject)
  end

  def member_signup_email(member, to_email)
    mail(to: to_email,
         from: 'SF Civic Music <no-reply@mail.sfcivicmusic.org>',
         subject: "New Member interested in joining the orchestra",
         body: "A new member has signed up!

                Name: #{member.first_name} #{member.last_name}

                Introduction: #{member.introduction}

                View them at https://members.sfcivicsymphony.org/members/#{member.id}")
  end

  def email_finished_email(to_email, email_title, recipient_count)
    mail(to: to_email,
         from: 'SFCMA Membership System <no-reply@mail.sfcivicmusic.org>',
         subject: 'Email Sent Successfully',
         body: "Your email, titled \"#{email_title}\", was sent to #{recipient_count} members successfully.

                Thanks for using the Membership System to keep our members informed!")

  end
end
