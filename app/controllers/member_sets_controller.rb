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
      member = Member.where('email_1 = ? OR email_2 = ?', msparams[:members][:email_1].strip, msparams[:members][:email_1].strip).first
    end

    member ? msparams[:member_id] = member.id : nil
    msparams.delete(:members)
    instrument = msparams[:new_performance_set_instrument_id]
    msparams.delete(:new_performance_set_instrument_id)
    out_email = nil

    @member_set = MemberSet.new(msparams)
    if !member
      respond_to do |format|
        Bugsnag.notify("Unable to find and opt-in member")
        format.html { redirect_to new_member_set_url, notice: "That email address doesn't have a member attached to it!<br><br>Please enter the email address you gave us, or contact membership@sfcivicsymphony.org for help." }
      end
    else
      @member_set.set_status = 'Opted In for this set'
      if MemberSet.where(performance_set_id: msparams[:performance_set_id], member_id: msparams[:member_id]).present?
        respond_to do |format|
          Bugsnag.notify("Unable to find and opt-in member")
          format.html { redirect_to new_member_set_url, notice: 'You have already opted in for this set!' }
        end
      else
        @performance_sets = PerformanceSet.now_or_future

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
                  if !current_user
                    format.html { redirect_to new_member_set_url, notice: "Thank you for submitting your interest in #{@member_set.performance_set.extended_name}." }
                  else
                    format.html { redirect_to @member_set, notice: "Thank you for submitting your interest in #{@member_set.performance_set.extended_name}." }
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