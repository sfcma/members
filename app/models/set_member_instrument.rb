class SetMemberInstrument < ApplicationRecord
  audited associated_with: :member_set
  acts_as_paranoid
  belongs_to :member_set
  belongs_to :member_instrument

  validates_associated :member_instrument
  validates :member_set, presence: { message: -> (_obj, _data) { 'Please include an instrument and set name on each set added.' } }
end
