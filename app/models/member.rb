class Member < ApplicationRecord
  audited
  acts_as_paranoid
  has_many :member_instruments
  has_many :member_sets
  has_many :member_notes
  accepts_nested_attributes_for :member_instruments, allow_destroy: true
  accepts_nested_attributes_for :member_sets, allow_destroy: true
  accepts_nested_attributes_for :member_notes, allow_destroy: true

  validates :first_name, presence: true
  validates_associated :member_sets, { message: -> (obj, data) { "Please include an instrument and set name on each set added." } }
  validates_associated :member_instruments, { message: -> (obj, data) { "uh oh" } }

  enum statuses: [:untriaged, :placed_in_group, :waitlist, :sub_only, :inactive]
end
