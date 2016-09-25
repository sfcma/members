class SetMemberInstrument < ApplicationRecord
  audited
  belongs_to :member_set
  belongs_to :member_instrument
end
