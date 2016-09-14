class Member < ApplicationRecord
  has_many :member_instruments
  has_many :member_sets
  has_many :member_notes
  accepts_nested_attributes_for :member_instruments, allow_destroy: true
  accepts_nested_attributes_for :member_sets, allow_destroy: true
  accepts_nested_attributes_for :member_notes, allow_destroy: true

  def statuses
    return ["Untriaged",
            "Placed in group",
            "Waitlist"
            "Sub-Only",
            "Inactive"]

end
