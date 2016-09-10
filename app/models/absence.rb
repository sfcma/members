class Absence < ApplicationRecord
  belongs_to :member
  belongs_to :performanceset
end
