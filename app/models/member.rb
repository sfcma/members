class Member < ApplicationRecord
  audited
  has_many :member_instruments
  has_many :member_sets
  has_many :member_notes
  accepts_nested_attributes_for :member_instruments, allow_destroy: true
  accepts_nested_attributes_for :member_sets, allow_destroy: true
  accepts_nested_attributes_for :member_notes, allow_destroy: true

  enum statuses: [:untriaged, :placed_in_group, :waitlist, :sub_only, :inactive]
end
