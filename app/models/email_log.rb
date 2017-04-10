class EmailLog < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid
  belongs_to :member
  belongs_to :email

  validates :member, presence: true
  validates :email, presence: true
end
