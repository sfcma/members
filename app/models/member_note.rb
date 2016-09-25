class MemberNote < ApplicationRecord
  audited associated_with: :member
  belongs_to :member
  belongs_to :user
end
