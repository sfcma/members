module CommunityNightsHelper
  def setup_community_night(community_night)
    if community_night.new_record?
      community_night.community_night_instruments = Array.new(10, CommunityNightInstrument.new)
    end
    community_night
  end
end
