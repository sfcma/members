class MemberCommunityNightsController < ApplicationController
  before_action :set_member_community_night, only: [:show, :edit, :update, :destroy]

  # GET /member_community_nights
  # GET /member_community_nights.json
  def index
    @member_community_nights = MemberCommunityNight.all
  end

  # GET /member_community_nights/1
  # GET /member_community_nights/1.json
  def show
  end

  # GET /member_community_nights/new
  def new
    @community_nights = CommunityNight.joinable
    @member_community_night = MemberCommunityNight.new
    render layout: 'anonymous' unless current_user.present?
  end

  # GET /member_community_nights/1/edit
  def edit
  end

  # POST /member_community_nights
  # POST /member_community_nights.json
  def create
    mcnparams = member_community_night_params

    # figure out which member it is
    if mcnparams[:members][:email_1].blank?
      member = nil
    else
      member = Member.where('lower(email_1) = lower(?) OR lower(email_2) = lower(?)', mcnparams[:members][:email_1].strip, mcnparams[:members][:email_1].strip).first
    end

    member ? mcnparams[:member_id] = member.id : nil
    mcnparams.delete(:members)
    instrument = mcnparams[:new_performance_set_instrument_id]
    mcnparams.delete(:new_performance_set_instrument_id)
    out_email = nil

    @member_community_night = MemberCommunityNight.new(mcnparams)
    if !member
      respond_to do |format|
        Bugsnag.notify("Unable to find and opt-in member - email not found")
        format.html { redirect_to new_member_community_night_url, notice: "We were unable to find a member with that email address.<br><br>If you have not played with us before, please fill out <b><a href='#{signup_members_path}?return_community_night=true'>this form</a></b>.<br><br>Please enter the email address you gave us, or contact membership@sfcivicsymphony.org for help." }
      end
    else
      if MemberCommunityNight.where(community_night_id: mcnparams[:community_night_id], member_id: mcnparams[:member_id]).present?
        respond_to do |format|
          Bugsnag.notify("Unable to find and opt-in member - already opted in")
          format.html { redirect_to new_member_community_night_url, notice: 'You have already opted in (or been added) for this set!' }
        end
      else
        psi = CommunityNightInstrument.find_by(instrument: instrument.downcase, community_night_id: mcnparams[:community_night_id])
        if psi
          psi_limit = psi.limit || 10000 # if there is no limit, make it a lot
          # THIS IS NAMED BACKWARDS
          if psi.available_to_opt_in
            respond_to do |format|
              format.html { redirect_to new_member_community_night_url, notice: "You are unable to opt in on this instrument. Contact membership@sfcivicsymphony.org for assistance." }
            end
            return
          elsif psi_limit > 0 && MemberCommunityNight.get_count(mcnparams[:community_night_id], [instrument]).count >= (psi_limit)
            respond_to do |format|
              format.html { redirect_to new_member_community_night_url, notice: "Sorry, this section is full for #{CommunityNight.find_by_id(mcnparams[:community_night_id]).extended_name}! <br><br>Please contact membership@sfcivicsymphony.org for assistance." }
            end
            return
          # elsif psi_limit > 0 && MemberCommunityNight.get_count(mcnparams[:community_night_id], [instrument]).count >= psi_limit
          #   opt_in_message = "Thank you for opting in as a standby player for #{CommunityNight.find_by_id(mcnparams[:community_night_id]).extended_name} this set.<br><br>"
          else
            opt_in_message = "Thank you for signing up for #{CommunityNight.find_by_id(mcnparams[:community_night_id]).name}!<br><br>"
          end
        else
          return_failure
        end

        if @member_community_night.save
          @member_instrument = MemberInstrument.where(member_id: member.id, instrument: instrument.downcase).first_or_initialize do |mi|
            mi.save!
          end
          if @member_instrument.present?
            @member_community_night.member_instrument_id = [@member_instrument.id]
            respond_to do |format|
              if @member_community_night.save
                money_message = ""
                # unless @member_set.standby_player
                #   money_message = "Ready to make your donation for this set? You can do that now via our <a href='http://sfcivicmusic.org/give-now'>online donations page</a>.<br><br>"
                # end
                if !current_user
                  format.html { redirect_to new_member_community_night_url, notice: "#{opt_in_message}#{money_message}".html_safe }
                else
                  format.html { redirect_to new_member_community_night_url, notice: "#{opt_in_message}#{money_message}".html_safe }
                  format.json { render :show, status: :created, location: @member_community_night }
                end
              else
                if current_user
                  format.html { render :new }
                else
                  format.html { render :new, layout: 'anonymous' }
                end
                Bugsnag.notify("Opt-in error")
                format.json { render json: @member_community_night.errors, status: :unprocessable_entity }
              end
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

  # PATCH/PUT /member_community_nights/1
  # PATCH/PUT /member_community_nights/1.json
  def update
    respond_to do |format|
      if @member_community_night.update(member_community_night_params)
        format.html { redirect_to @member_community_night, notice: 'Member community night was successfully updated.' }
        format.json { render :show, status: :ok, location: @member_community_night }
      else
        format.html { render :edit }
        format.json { render json: @member_community_night.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /member_community_nights/1
  # DELETE /member_community_nights/1.json
  def destroy
    @member_community_night.destroy
    respond_to do |format|
      format.html { redirect_to member_community_nights_url, notice: 'Member community night was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member_community_night
      @member_community_night = MemberCommunityNight.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_community_night_params
      params.require(:member_community_night).permit(:new_performance_set_instrument_id, :instrument, :member_id, :community_night_id,
      members: [
        :email_1
      ])
    end
end
