class MemberNote < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid
  belongs_to :member
  belongs_to :user

  validates :member, presence: true
  validates :user, presence: true
  validates :note, presence: true

end
