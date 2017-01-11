class MemberInstrument < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid
  belongs_to :member
  has_many :set_member_instruments
  accepts_nested_attributes_for :set_member_instruments, allow_destroy: true
  validates :instrument, presence: true, uniqueness: { scope: :member_id, message: 'each member can only have each instrument listed once' }
  before_save { |mi| mi.instrument = mi.instrument.underscore }

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end
end
