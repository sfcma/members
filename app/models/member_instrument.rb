class MemberInstrument < ApplicationRecord
  belongs_to :member
  has_many :set_member_instrument
  validates :instrument, presence: true
  before_save { |mi| mi.instrument = mi.instrument.downcase }
end
