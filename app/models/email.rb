class Email < ApplicationRecord
  audited
  acts_as_paranoid
  belongs_to :user
  belongs_to :performance_set

  validates :email_body, presence: true
  validates :email_title, presence: true
  validates :user, presence: true

  has_many :email_logs

  accepts_nested_attributes_for :email_logs

  enum statuses_for_email: ["Confirmed Playing ONLY",
                            "Confirmed Playing and Opted-In",
                            "Confirmed Playing, Opted-In, Interested, and Subbing"]

end
