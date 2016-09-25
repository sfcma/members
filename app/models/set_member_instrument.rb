class SetMemberInstrument < ApplicationRecord
  audited associated_with: :member_set
  belongs_to :member_set
  belongs_to :member_instrument
end
