class MemberSet < ApplicationRecord
  has_many :set_member_instruments
  belongs_to :member
  belongs_to :performance_set
  accepts_nested_attributes_for :set_member_instruments, allow_destroy: true
end
