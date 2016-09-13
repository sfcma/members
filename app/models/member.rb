class Member < ApplicationRecord
  has_many :member_instruments
  accepts_nested_attributes_for :member_instruments, allow_destroy: true
end
