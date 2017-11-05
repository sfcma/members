class CommunityNightInstrument < ApplicationRecord
  belongs_to :community_night
  before_save { |cni| cni.instrument = cni.instrument.underscore }

  validates :instrument, presence: true
end
