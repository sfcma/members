class SetMemberInstrument < ApplicationRecord
  belongs_to :performance_set
  belongs_to :member_instrument
end
