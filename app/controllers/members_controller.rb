class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /members
  # GET /members.json
  def index
    @instruments = MemberInstrument.all.map { |mi| [mi.instrument.capitalize, mi.instrument] }.uniq

    if params[:instrument]
      @members = Member.joins(:member_instruments).where('instrument = ?', params[:instrument].snake_case)
    else
      @members = Member.includes(:member_instruments)
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member_instruments = @member.member_instruments
    @audit_string = helpers.generate_audit_array(@member)
  end

  # GET /members/new
  def new
    @sets = PerformanceSet.all
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
    @sets = PerformanceSet.all
    @member.member_instruments.build
    @member.member_sets.build
    @member.member_sets.each do |ms|
      ms.set_member_instruments.build
    end
    @member.member_notes.build
    @member_instruments = @member.member_instruments
  end

  # POST /members
  # POST /members.json
  def create
    new_member_params = member_params.dup
    new_member_params[:member_instruments_attributes].reject! do |_, miv|
      miv['instrument'] && miv['instrument'].empty?
    end
    new_member_params[:member_sets_attributes].reject! do |_, miv|
      miv['set_id'] && miv['set_id'].empty?
    end
    @member = Member.new(new_member_params)

    set_member_instruments = {}
    member_sets = new_member_params[:member_sets_attributes]
    member_sets.each do |_, ms|
      set_member_instruments[ms[:set_id]] = ms.delete(:set_member_instruments_attributes)
    end
    respond_to do |format|
      if @member.save
        @member.member_sets.each do |smi|
          next unless smi.set_id && smi.set_id > 0
          mi = MemberInstrument.new(member_id: @member.id, instrument: set_member_instruments[smi.set_id.to_s]["0"][:member_instrument_id].underscore)
          mi.save!

          member_instrument_id = MemberInstrument.where(member_id: @member.id, instrument: set_member_instruments[smi.set_id.to_s]["0"][:member_instrument_id].underscore).first.id
          smix = SetMemberInstrument.where(member_set_id: smi.id).first
          smix.member_instrument_id = member_instrument_id

          if smix.save!
            go_back = 'Member was successfully created.'
            format.html { redirect_to new_member_path, notice: go_back }
          else
            format.html { render :edit }
          end
        end
        format.html { render :edit, notice: 'OH NO'}
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    @sets = PerformanceSet.all
    new_member_params = member_params.dup
    new_member_params[:member_instruments_attributes].reject! do |_, miv|
      miv['instrument'] && miv['instrument'].empty?
    end
    new_member_params[:member_sets_attributes].reject! do |_, miv|
      miv['set_id'] && miv['set_id'].empty?
    end
    set_member_instruments = {}
    member_sets = new_member_params[:member_sets_attributes]
    member_sets.each do |_, ms|
      set_member_instruments[ms[:set_id]] = ms.delete(:set_member_instruments_attributes)
    end

    respond_to do |format|
      puts new_member_params.inspect
      puts @member.inspect
      if @member.update(new_member_params)
        @member.member_sets.each do |smi|
          next unless smi.set_id && smi.set_id > 0
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
          if smix.save!
            format.html { redirect_to @member, notice: 'Member was successfully updated.' }
          else
            format.html { render :edit }
          end
        end
        format.html { render :edit, notice: 'OH NO'}
      else
        format.html { render :edit }
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
