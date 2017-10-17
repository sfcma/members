class Email < ApplicationRecord
  audited
  acts_as_paranoid
  belongs_to :user
  belongs_to :performance_set
  belongs_to :ensemble

  validates :email_body, presence: true
  validates :email_title, presence: true
  validates :user, presence: true

  has_many :email_logs
  has_many :attachments, dependent: :destroy

  accepts_nested_attributes_for :email_logs

  enum statuses_for_email: ["Confirmed Playing",
                            "Confirmed Playing or Interested",
                            "Confirmed Playing, Interested, or Subbing"]

  def self.statuses_for_general_use
    statuses_for_emails.merge("All, including those who are not playing": 3)
  end

end
