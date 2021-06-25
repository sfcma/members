class MembersController < ApplicationController
  before_action :set_member, only: [:show, :vaccination_status, :edit, :update, :destroy, :send_email, :update_vaccination_status]
  before_action :authenticate_user!, except: [:requires_sub_name, :signup, :create_from_signup, :signup_complete]
  before_action :load_sets
  impressionist except: [:get_filtered_member_info]

  # boo
  include MembersHelper

  # GET /members
  # GET /members.json
  def index
    @instruments = MemberInstrument.all.map { |mi| [mi.instrument.capitalize, mi.instrument] }.uniq
    @instruments = @instruments.sort { |x, y| x[0] <=> y[0] }
    @instruments = @instruments.unshift(['All Instruments', 0])

    @performance_sets_for_filter = PerformanceSet.all.map { |ps| [ps.extended_name, ps.id] }
    @performance_sets_for_filter = @performance_sets_for_filter.unshift(['All Sets', 0])

    @instrument_label = 0
    @performance_set_label = 0

    joins = []

    @member_instruments = {}
    MemberInstrument.includes(:member).all.map do |m|
      if m.member && @member_instruments[m.member.id]
        @member_instruments[m.member.id].push(m)
      elsif m.member
        @member_instruments[m.member.id] = [m]
      end
    end

    @member_sets = {}
    MemberSet.includes(:member).all.map do |m|
      if m.member && @member_sets[m.member.id]
        @member_sets[m.member.id].push(m)
      elsif m.member
        @member_sets[m.member.id] = [m]
      end
    end

    @performance_sets = {}
    PerformanceSet.all.map do |ps|
      @performance_sets[ps.id] = ps
    end

    if params[:instrument]
      if MemberInstrument.where('instrument = ?', params[:instrument]).count > 0
        @instrument = params[:instrument]
        @instrument_label = @instrument
      end
    end
    if params[:set]
      if PerformanceSet.where('id = ?', params[:set]).count > 0
        @performance_set = params[:set]
        @performance_set_label = @performance_set
      end
    end

    @members = Member.all

    if @instrument
      @members = @members.to_a.keep_if {|m| m.member_instruments.map(&:instrument).include?(@instrument.humanize.downcase) }
    end
    if @performance_set
      @members = @members.includes(:member_sets).to_a.keep_if {|m| m.member_sets.map(&:performance_set_id).include?(params[:set].to_i) }
    end

    @members = @members.sort_by(&:last_name)
  end

  # GET /members/1
  # GET /members/1.json
  def show



    @audit_string = helpers.generate_audit_array(@member)
    @audit_string += helpers.generate_audit_array(@member.member_instruments.with_deleted.all.to_a)
    @audit_string += helpers.generate_audit_array(@member.member_sets.with_deleted.all.to_a)
    @audit_string += helpers.generate_audit_array(@member.member_notes.with_deleted.all.to_a)
    @audit_string.flatten!
    @audit_string += Impression.where(:controller_name => 'members', :impressionable_id => @member.id).map{|s| { html: format_impression_string(s), audit_created_at: s.created_at.in_time_zone('Pacific Time (US & Canada)') } }
    puts @audit_string.map { |as| as[:audit_created_at] }
    @audit_string = @audit_string.sort_by { |as| as[:audit_created_at] }.reverse

    if (can_view_member_personal_info(@member))
      @notes = @member.member_notes
    else
      @notes = @member.member_notes.where(private_note: false)
    end
  end

  # GET /members/1/vaccination_status
  def vaccination_status
    unless current_user.vaccination_manager?
      format.json { render json: { notice: 'You do not have permissions to view vaccination statuses' }, status: :ok } and return
    end 
    respond_to do |format|
      format.json { render json: { vaccination_status: @member.vaccination_status }, status: :ok }
    end
  end

  # GET /members/new
  def new
    @member = Member.new
    @member.member_instruments.build
    @member.member_sets.build
    @member.member_notes.build
    @member.member_sets.each do |ms|
      ms.set_member_instruments.build
    end
    @member_instruments = []
  end

  # GET /members/1/edit
  def edit
    if !can_view_member_personal_info(@member)
      redirect_to(@member, notice: "You do not have permissions to edit #{@member.first_name} #{@member.last_name}. Check what instruments and ensembles you have permissions to view") and return
    end
    @member.member_instruments.build
    @member.member_sets.build
    @member.member_sets.each do |ms|
      ms.set_member_instruments.build
    end
    @member.member_notes.build
  end

  # POST /members
  # POST /members.json
  def create
    new_member_params, set_member_instruments = manipulate_member_params(member_params)

    @member = Member.new(new_member_params)
    respond_to do |format|
      if @member.save
        @member.member_sets.each do |member_set|
          next if destroy_empty_member_sets(member_set)

          member_instrument_id, instrument_name = get_member_instrument_id(set_member_instruments, member_set)
          variant = nil
          if instrument_name =~ /violin/
            variant = instrument_name
          end
          set_member_instrument = get_set_member_instrument(member_instrument_id, member_set, variant)

          if set_member_instrument.save
            format.html { render :show, notice: 'Member was successfully created.' }
          else
            format.html { render :new, notice: 'Error saving set member instrument' }
          end
        end
        format.html { redirect_to(@member, notice: 'Member was successfully updated.') }
      else
        format.html { render :new, notice: 'OH NO' }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    new_member_params, set_member_instruments = manipulate_member_params(member_params)

    respond_to do |format|
      if @member.update(new_member_params)
        @member.member_sets.each do |member_set|
          next if destroy_empty_member_sets(member_set)

          member_instrument_id, instrument_name = get_member_instrument_id(set_member_instruments, member_set)
          variant = nil
          if instrument_name =~ /violin/
            variant = instrument_name
          end
          set_member_instrument = get_set_member_instrument(member_instrument_id, member_set, variant)

          if set_member_instrument.save
            format.html { render :show, notice: 'Member was successfully updated.' }
          else
            format.html { render :edit, notice: 'Error saving set member instrument' }
          end
        end
        format.html { redirect_to(@member, notice: 'Member was successfully updated.') }
      else
        format.html { render :edit, notice: 'OH NO' }
      end
    end
  end

  # PATCH /members/update_vaccination_status.json
  def update_vaccination_status
    unless current_user.vaccination_manager?
      redirect_to @member, notice: 'You do not have permissions to edit vaccination statuses' and return
    end
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_from_signup
    community_night_referral = member_params[:community_night_referral]
    @member = Member.new(member_params.except(:community_night_referral))
    @member.initial_date = Time.now
    respond_to do |format|
      if (verify_recaptcha(model: @member) || ENV['RAILS_ENV'] != 'production') && @member.save
        if (community_night_referral == 'true')
          return_url = new_member_community_night_url
          return_msg = 'Thank you for signing up for membership in the San Francisco Civic Music Association!<br><br>Please use this form to finish RSVP\'ing for the upcoming Community Night'.html_safe
        else
          return_url = signup_complete_members_url
          return_msg = 'Thank you for signing up for membership in the San Francisco Civic Music Association!<br><br>A representative from our Membership Committee will be in touch with you in the next few days to discuss our current openings and help find the best fit for you.'.html_safe
        end
        MemberMailer.member_signup_email(@member, community_night_referral == 'true', 'membership@sfcivicmusic.org').deliver_now
        MemberMailer.member_signup_email(@member, community_night_referral == 'true', 'helentsang@tsangarchitects.com').deliver_now
        format.html { redirect_to(return_url, notice: return_msg) }
      else
        format.html { render(:signup, layout: 'anonymous', notice: 'Unfortunately, we were unable to save your record. Please try again or contact membership@sfcivicmusic.org.') }
      end
    end
  end

  def signup_complete
    render layout: 'anonymous' unless current_user.present?
  end

  def send_email
    MemberMailer.standard_member_email(@member, 'Test Email Subject', 'Test Email Body', current_user).deliver_now
    respond_to do |format|
      format.html { redirect_to members_url, notice: "Email to #{@member.first_name} #{@member.last_name} successfully sent." }
      format.json { head :no_content }
    end
  end

  def requires_sub_name
    member_email_address = params[:member_email]
    performance_set_id = params[:performance_set_id]

    if member_email_address.blank?
      respond_to do |format|
        format.json { render json: false, status: :ok }
      end
      return
    else
      member = Member.find_by('lower(email_1) = lower(?) OR lower(email_2) = lower(?)', member_email_address.strip, member_email_address.strip)
      if !member
        respond_to do |format|
          format.json { render json: false, status: :ok }
        end
        return
      end
    end

    member_set = MemberSet.find_by('member_id = ? and performance_set_id = ?', member.id, performance_set_id)

    if !member_set
      respond_to do |format|
        format.json { render json: false, status: :ok }
      end
      return
    end

    if member_set.set_member_instruments
      instrument_name = member_set.set_member_instruments.first.member_instrument.instrument
      if Absence::INSTRUMENTS_REQUIRING_SUBS.include?(instrument_name)
        respond_to do |format|
          format.json { render json: true, status: :ok }
        end
        return
      end
    else
      respond_to do |format|
        format.json { render json: false, status: :ok }
      end
    end
  end

  def get_filtered_member_info
    instruments = params[:instruments] || ""
    performance_set_id = params[:performance_set_id]
    ensemble_id = params[:ensemble_id]
    status_id = params[:status]
    all = params[:all]
    chamber = params[:chamber]

    instruments = "" if instruments == "null"
    if performance_set_id
      member_sets = MemberSet.filtered_by_criteria(performance_set_id, status_id, instruments.split(','))
      respond_to do |format|
        format.json { render json: member_sets.to_json(include: [:set_member_instruments, member: {include: [:member_instruments] }]), status: :ok }
      end
    elsif ensemble_id
      performance_set_ids = PerformanceSet
        .where('end_date > ?', 1.year.ago.strftime('%F'))
        .where(ensemble_id: ensemble_id)
        .map(&:id)
      member_ids = Member.played_with_ensemble_last_year(ensemble_id)
      member_sets = MemberSet.includes(:set_member_instruments, member: [:member_instruments]).where(performance_set_id: performance_set_ids, member_id: member_ids)
      respond_to do |format|
        format.json { render json: member_sets.to_json(include: [:set_member_instruments, member: {include: [:member_instruments] }]), status: :ok }
      end
    elsif all
      performance_set_ids = PerformanceSet
        .where('end_date > ?', 1.year.ago.strftime('%F'))
        .map(&:id)
      member_sets = MemberSet.includes(:set_member_instruments, member: [:member_instruments]).where(performance_set_id: performance_set_ids, member_id: Member.played_with_any_ensemble_last_year)
      respond_to do |format|
        format.json { render json: member_sets.to_json(include: [:set_member_instruments, member: {include: [:member_instruments] }]), status: :ok }
      end
    elsif chamber
      performance_set_ids = PerformanceSet
        .where('end_date > ?', 1.year.ago.strftime('%F'))
        .map(&:id)
      performing_members = MemberSet.includes(member: [:member_instruments]).where('performance_set_id in (?) and member_id in (?)', performance_set_ids, Member.played_with_any_ensemble_last_year).map(&:member)
      recent_members = Member.joined_last_six_months
      all_to_email = (performing_members + recent_members).uniq
      if instruments.present?
        all_to_email = all_to_email.select { |member| member.member_instruments.any? { |mi| instruments.include?(mi.instrument) } }
      end
      respond_to do |format|
        format.json { render json: all_to_email.to_json(include: [:member_instruments]), status: :ok }
      end
      return
    else
      respond_to do |format|
        format.json { render json: member_sets.to_json(include: [:set_member_instruments, member: {include: [:member_instruments] }]), status: :ok }
      end
    end
  end

  def signup
    if current_user.present?
      redirect_to new_member_url, notice: 'Cannot use anonymous new member signup form while signed in'
    end
    @member = Member.new
    render layout: 'anonymous' unless current_user.present?
  end

  def waivers
  end

  # Get email addresses members for a certain set for a certain instrument
  # SetMemberInstrument.joins('INNER JOIN member_sets on member_sets.id = set_member_instruments.member_set_id').joins('INNER JOIN member_instruments on member_instruments.id = set_member_instruments.member_instrument_id').where('member_instruments.instrument = ? OR member_instruments.instrument = ?', 'violin 1', 'violin 1').where(member_sets: { performance_set_id: [1,6,9,12]}).map(&:member_set).map(&:member).map(&:email_1).join(", ")

  # Get email addresses for members for a particular instrument in certain sets
  # Member.all.joins('INNER JOIN member_instruments on member_instruments.member_id = members.id').joins('INNER JOIN member_sets on member_sets.member_id = members.id').where('member_instruments.instrument = ?', 'violin').where(member_sets: {performance_set_id: [1,6,9,12]}).map{|m| "#{m.email_1}" }.uniq.join(", ")

  private

  # Sanitize input params for members.
  # Note that this method only supports one instrument per member_set right now
  def manipulate_member_params(member_params)
    # Remove any empty instrument fields
    if member_params[:member_instruments_attributes]
      member_params[:member_instruments_attributes].reject! do |_, member_instrument_fields|
        member_instrument_fields['instrument'] && member_instrument_fields['instrument'].empty?
      end
    end

    if member_params[:member_notes_attributes]
      member_params[:member_notes_attributes].each do |_, member_notes|
        member_notes['user_id'] = current_user.id
      end
    end

    if member_params[:member_sets_attributes]
      # Remove any empty sets
      member_params[:member_sets_attributes].reject! do |_, member_sets_fields|
        member_sets_fields['performance_set_id'] && member_sets_fields['performance_set_id'].empty?
      end

      # Create a new hash of {performance set id => set member instrument attributes}
      set_member_instruments = {}

      # Go through each set
      member_params[:member_sets_attributes].each do |_, member_sets_fields|
        # Remove the set_member_instrument from the main member hash, and attach
        # by performance_set_id key to a separate hash
        # Each set only is allowed to have one instrument (set_member_instrument) attached right now
        set_member_instruments[member_sets_fields[:performance_set_id]] = member_sets_fields.delete(:set_member_instruments_attributes)
      end
    end

    [member_params, set_member_instruments]
  end

  def get_member_instrument_id(set_member_instruments, member_set)
    instrument_name = set_member_instruments[member_set.performance_set_id.to_s]['0'][:member_instrument_id].underscore
    if instrument_name =~ /violin/
      partless_instrument_name = 'violin'
    else
      partless_instrument_name = instrument_name
    end
    [MemberInstrument.find_or_create_by!(member_id: @member.id, instrument: partless_instrument_name).id, instrument_name]
  end

  def get_set_member_instrument(member_instrument_id, member_set, variant)
    if !SetMemberInstrument.where(member_set_id: member_set.id).empty?
      smix = SetMemberInstrument.where(member_set_id: member_set.id).first
      smix.member_instrument_id = member_instrument_id
      smix.variant = variant
    else
      smix = SetMemberInstrument.new(member_set_id: member_set.id, member_instrument_id: member_instrument_id, variant: variant)
    end
    smix
  end

  def destroy_empty_member_sets(member_set)
    unless member_set.performance_set_id && member_set.performance_set_id > 0
      member_set.destroy
      true
    end
    false
  end

  def load_sets
    @performance_sets = PerformanceSet.all
    @member_instruments = @member.member_instruments if @member
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def member_params
    params.require(:member).permit(
      :first_name,
      :last_name,
      :address_1,
      :address_2,
      :city,
      :state,
      :zip,
      :phone_1,
      :phone_1_type,
      :phone_2,
      :phone_2_type,
      :email_1,
      :email_2,
      :emergency_name,
      :emergency_relation,
      :program_name,
      :emergency_phone,
      :playing_status,
      :initial_date,
      :waiver_signed,
      :contact_reply_date,
      :reply_user_id,
      :introduction,
      :source_website,
      :source_other,
      :community_night_referral,
      :vaccination_status,
      member_instruments_attributes: [
        :id,
        :instrument,
        :_destroy
      ],
      member_sets_attributes: [
        :id,
        :performance_set_id,
        :status,
        :rotating,
        :standby_player,
        :set_status,
        :_destroy,
        set_member_instruments_attributes: [:member_instrument_id],
      ],
      member_notes_attributes: [
        :id,
        :note,
        :private_note
      ]
    )
  end
end
