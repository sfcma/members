require 'instruments'
module PerformanceSetsHelper
  include Instruments

  def organize_members_by_instrument(member_sets)
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

    @instrument_groups.sort_by { |e, v| Instruments.instruments.index(e) || Instruments.instruments.length }.to_h
  end

  def setup_performance_set(performance_set)
    if performance_set.new_record?
      performance_set.performance_set_instruments = Array.new(20, PerformanceSetInstrument.new)
      performance_set.performance_set_dates = Array.new(10, PerformanceSetDate.new)
    end
    performance_set
  end

end
