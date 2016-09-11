class MemberInstrument < ApplicationRecord
  belongs_to :member
  has_many :set_member_instrument
end
