class Absence < ApplicationRecord
  audited associated_with: [:member, :performance_set]
  belongs_to :member
  belongs_to :performance_set
end
