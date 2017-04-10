module PerformanceSetsHelper

  def organize_members_by_instrument(performance_set, member_sets)
    @instrument_groups = {}
    member_sets.each do |ms|
      if ms.set_member_instruments.present?
        instrument = ms.set_member_instruments.first.instrument_name_with_variant
      else
        instrument = "None"
      end
      @instrument_groups[instrument] ||= []
      @instrument_groups[instrument] << ms
    end

    @instrument_groups
  end
end
