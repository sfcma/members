class EmailLog < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid
  has_one :member, :email

  validates :member, present: true
  validates :email, present: true
end
