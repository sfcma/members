class MemberInstrument < ApplicationRecord
  belongs_to :member
  has_many :set_member_instruments
  accepts_nested_attributes_for :set_member_instruments, allow_destroy: true
  validates :instrument, presence: true
  before_save { |mi| mi.instrument = mi.instrument.downcase }
end
