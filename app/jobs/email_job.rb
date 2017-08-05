


class EmailJob
  include SuckerPunch::Job

  def perform(job, email, member_ids, current_user)
    Rails.logger.info "Sending email"
    unless email.sent_at.nil?
      respond_to do |format|
        format.html { redirect_to email_url(email), notice: 'Cannot re-send email already sent.' }
        format.json { head :no_content }
      end
      return
    end
    unless member_ids.present?
      respond_to do |format|
        format.html { redirect_to email_url(email), notice: 'No members to send to.' }
        format.json { head :no_content }
      end
      return
    end

    members = Member.find(member_ids.split(",").map{ |mi| mi.to_i })

    members.each do |member|
      begin
        Rails.logger.info "Sending email #{email.id} to #{member.id}"
        member_insts = MemberInstrument.where(member_id: member.id)
        smi = SetMemberInstrument.where(member_instrument_id: member_insts.map(&:id), member_set_id: MemberSet.where(member_id: member.id, performance_set_id: email.performance_set.id))
        if member.email_1.present?
          MemberMailer.standard_member_email(member, email.email_title, email.email_body, current_user, email.id, member.id, email.performance_set.extended_name, email.instruments, email.status, smi).deliver_now
        else
          Bugsnag.notify("No email address available for member: #{member.id}")
        end
        EmailLog.new(email_id: email.id, member_id: member.id, created_at: Time.now).save
      rescue StandardError => e
        Bugsnag.notify(e)
      end
    end
    email.update(sent_at: Time.now)

    MemberMailer.email_finished_email(current_user.email, email.email_title, members.count).deliver_now

  end
end
