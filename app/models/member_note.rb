class MemberNote < ApplicationRecord
  audited
  belongs_to :member
  belongs_to :user
end
