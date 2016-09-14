class MemberSet < ApplicationRecord
  has_many :set_member_instruments
  belongs_to :member
  belongs_to :performance_set
  accepts_nested_attributes_for :set_member_instruments, allow_destroy: true
  validates :performance_set, presence: true

  def statuses
    return
      ["Interested",
       "Playing",
       "Played but stopped",
       "Forced to stop playing",
       "Subbing",
       "Rolled Over -- Unconfirmed",
       "Not Interested"]
  end
end
