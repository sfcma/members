class MemberSetsController < ApplicationController
  def new
    @performance_sets = PerformanceSet.joinable
    @member_set = MemberSet.new
    render layout: 'anonymous' unless current_user.present?
  end

  def create
    msparams = member_sets_params

    # figure out which member it is
    if msparams[:members][:email_1].blank?
      member = nil
    else
      member = Member.where('lower(email_1) = lower(?) OR lower(email_2) = lower(?)', msparams[:members][:email_1].strip, msparams[:members][:email_1].strip).first
    end

    member ? msparams[:member_id] = member.id : nil
    msparams.delete(:members)
    instrument = msparams[:new_performance_set_instrument_id]
    msparams.delete(:new_performance_set_instrument_id)
    out_email = nil

    @member_set = MemberSet.new(msparams)
    if !member
      respond_to do |format|
        # Bugsnag.notify("Unable to find and opt-in member - email not found")
        format.html { redirect_to new_member_set_url, notice: "We were unable to find a member with that email address.<br><br>Please enter the email address you gave us, or contact membership@sfcivicmusic.org for help.<br><br>If you have not played with us before, please fill out <b><a href='#{signup_members_path}'>this form</a></b>." }
      end
    else
      @member_set.set_status = :interested
      if MemberSet.where(performance_set_id: msparams[:performance_set_id], member_id: msparams[:member_id]).present?
        respond_to do |format|
          # Bugsnag.notify("Unable to find and opt-in member - already opted in")
          format.html { redirect_to new_member_set_url, notice: 'You have already opted in (or been added) for this set!' }
        end
      else
        @performance_sets = PerformanceSet.now_or_future

        psi = PerformanceSetInstrument.find_by(instrument: instrument.downcase, performance_set_id: msparams[:performance_set_id])
        if psi
          psi_limit = psi.limit || 10000 # if there is no limit, make it a lot
          # THIS IS NAMED BACKWARDS
          if psi.available_to_opt_in
            respond_to do |format|
              format.html { redirect_to new_member_set_url, notice: OptInMessage.find_by_id(psi.opt_in_message_id) && OptInMessage.find_by_id(psi.opt_in_message_id).message || "You are unable to opt in on this instrument. Contact your section leader or membership@sfcivicmusic.org for assistance." }
            end
            return
          elsif psi_limit > 0 && MemberSet.filtered_by_criteria(msparams[:performance_set_id], 4, [instrument]).count >= (psi_limit + psi.standby_limit)
            respond_to do |format|
              format.html { redirect_to new_member_set_url, notice: OptInMessage.find_by_id(psi.opt_in_message_id) && OptInMessage.find_by_id(psi.opt_in_message_id).message || "Sorry, this section is full for #{PerformanceSet.find_by_id(msparams[:performance_set_id]).extended_name}! <br><br>Please contact your section leader or membership@sfcivicmusic.org for assistance." }
            end
            return
          elsif psi_limit > 0 && MemberSet.filtered_by_criteria(msparams[:performance_set_id], 4, [instrument]).count >= psi_limit
            @member_set.standby_player = true
            opt_in_message = "Thank you for opting in as a standby player for #{PerformanceSet.find_by_id(msparams[:performance_set_id]).extended_name} this set.<br><br>"
          else
            opt_in_message = OptInMessage.find_by_id(psi.opt_in_message_id)
            opt_in_message = opt_in_message.present? ? "#{opt_in_message.message}<br><br>" : "Thank you for submitting your interest in #{PerformanceSet.find_by_id(msparams[:performance_set_id]).extended_name}.<br><br>"
          end
        else
          return_failure
        end

        if @member_set.save
          @member_instrument = MemberInstrument.where(member_id: member.id, instrument: instrument.downcase).first_or_initialize do |mi|
            mi.save!
          end
          if @member_instrument.present?
            @set_member_instrument = SetMemberInstrument.where(member_set_id: @member_set.id, member_instrument_id: @member_instrument.id).first_or_initialize do |smi|
              smi.save!
            end
            if @set_member_instrument.present?
              @member_set.set_member_instruments = [@set_member_instrument]
              respond_to do |format|
                if @member_set.save
                  money_message = ""
                  unless @member_set.standby_player
                    money_message = "Ready to make your donation for this set? You can do that now via our <a href='http://sfcivicmusic.org/give-now'>online donations page</a>.<br><br>"
                  end
                  if !current_user
                    format.html { redirect_to new_member_set_url, notice: "#{opt_in_message}#{money_message}Need to report an absence? You can do that now via <a href='http://missing.sfcivicsymphony.org'>missing.sfcivicsymphony.org</a>.".html_safe }
                  else
                    format.html { redirect_to new_member_set_url, notice: "#{opt_in_message}#{money_message}Need to report an absence? You can do that now via <a href='http://missing.sfcivicsymphony.org'>missing.sfcivicsymphony.org</a>.".html_safe }
                    format.json { render :show, status: :created, location: @member_set }
                  end
                else
                  if current_user
                    format.html { render :new }
                  else
                    format.html { render :new, layout: 'anonymous' }
                  end
                  Bugsnag.notify("Opt-in error")
                  format.json { render json: @member_set.errors, status: :unprocessable_entity }
                end
              end
            else
              return_failure
            end
          else
            return_failure
          end
        else
          return_failure
        end
      end
    end
  end

  private

  def return_failure
    respond_to do |format|
      Bugsnag.notify("Opt-in error")
      format.html { render :new, layout: 'anonymous' }
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_sets_params
    params.require(:member_set).permit(
      :performance_set_id,
      :instrument,
      :new_performance_set_instrument_id,
      members: [
        :email_1
      ]
    )
  end

end
