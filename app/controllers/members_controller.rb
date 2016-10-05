class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :load_sets
  impressionist

  # GET /members
  # GET /members.json
  def index
    @instruments = MemberInstrument.all.map { |mi| [mi.instrument.capitalize, mi.instrument] }.uniq
    joins = []

    if params[:instrument]
      joins << :member_instruments
    end
    if params[:set]
      joins << :member_sets
    end

    @members = Member.joins(joins)

    if params[:instrument]
      @members.where("instrument = ?", params[:instrument])
    end
    if params[:set]
      @members.where("set_id = ?", params[:set])
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @audit_string = helpers.generate_audit_array(@member)
    @audit_string += helpers.generate_audit_array(@member.member_instruments.with_deleted.all.to_a)
    @audit_string += helpers.generate_audit_array(@member.member_sets.with_deleted.all.to_a)
    @audit_string.sort_by do |as|
      #as.created_at
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
        @member.member_sets.each do |smi|
          unless smi.set_id && smi.set_id > 0 && smi.set_member_instrument_ids.length > 0
            smi.destroy
            next
          end
          mi = MemberInstrument.new(member_id: @member.id, instrument: set_member_instruments[smi.set_id.to_s]["0"][:member_instrument_id].underscore)
          mi.save!

          member_instrument_id = MemberInstrument.where(member_id: @member.id, instrument: set_member_instruments[smi.set_id.to_s]["0"][:member_instrument_id].underscore).first.id
          smix = SetMemberInstrument.where(member_set_id: smi.id).first
          smix.member_instrument_id = member_instrument_id

          if smix.save!
            go_back = 'Member was successfully created.'
            format.html { redirect_to @member, notice: go_back }
          else
            format.html { render :show }
          end
        end
        format.html { render :show, notice: 'OH NO'}
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    new_member_params, set_member_instruments = manipulate_member_params(member_params)

    respond_to do |format|
      puts new_member_params.inspect
      puts @member.inspect
      if @member.update(new_member_params)
        @member.member_sets.each do |smi|
          unless smi.set_id && smi.set_id > 0 && smi.set_member_instrument_ids.length > 0
            smi.destroy
            next
          end
          if MemberInstrument.where(member_id: @member.id, instrument: set_member_instruments[smi.set_id.to_s]["0"][:member_instrument_id].underscore).count == 0
            mi = MemberInstrument.new(member_id: @member.id, instrument: set_member_instruments[smi.set_id.to_s]["0"][:member_instrument_id].underscore)
            mi.save!
          end
          member_instrument_id = MemberInstrument.where(member_id: @member.id, instrument: set_member_instruments[smi.set_id.to_s]["0"][:member_instrument_id].underscore).first.id
          if SetMemberInstrument.where(member_set_id: smi.id).length > 0
            smix = SetMemberInstrument.where(member_set_id: smi.id).first
            smix.member_instrument_id = member_instrument_id
          else
            smix = SetMemberInstrument.new(member_set_id: smi.id, member_instrument_id: member_instrument_id)
          end
          if smix.save
            format.html { redirect_to @member, notice: 'Member was successfully updated.' }
          else
            format.html { render :edit, notice: 'Error saving set member instrument' }
          end
        end
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
      else
        format.html { render :edit, notice: 'OH NO' }
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

    if member_params[:member_sets_attributes]
      # Remove any empty sets
      member_params[:member_sets_attributes].reject! do |_, member_sets_fields|
        member_sets_fields['set_id'] && member_sets_fields['set_id'].empty?
      end

      # Create a new hash of {performance set id => set member instrument attributes}
      set_member_instruments = {}

      # Go through each set
      member_params[:member_sets_attributes].each do |_, member_sets_fields|
        # Remove the set_member_instrument from the main member hash, and attach
        # by set_id key to a separate hash
        # Each set only is allowed to have one instrument (set_member_instrument) attached right now
        set_member_instruments[member_sets_fields[:set_id]] = member_sets_fields.delete(:set_member_instruments_attributes)
      end
    end

    [member_params, set_member_instruments]
  end

  def load_sets
    @sets = PerformanceSet.all
    if @member
      @member_instruments = @member.member_instruments
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def member_params
    params.require(:member).permit(:first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone_1, :phone_1_type, :phone_2, :phone_2_type, :email_1, :email_2, :emergency_name, :emergency_relation, :emergency_phone, :playing_status, :initial_date, :waiver_signed, member_instruments_attributes: [:id, :instrument, :_destroy], member_sets_attributes: [:id, :set_id, :status, :rotating, :set_status, :_destroy, set_member_instruments_attributes: [:member_instrument_id]])
  end
end
