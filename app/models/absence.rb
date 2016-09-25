class Absence < ApplicationRecord
  audited
  belongs_to :member
  belongs_to :performanceset
end
