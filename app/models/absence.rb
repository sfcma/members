class Absence < ApplicationRecord
  audited associated_with: :member
  belongs_to :member
  belongs_to :performance_set
end
