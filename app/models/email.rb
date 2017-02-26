class Email < ApplicationRecord
  audited
  acts_as_paranoid
  has_one :user
  has_one :performance_set
  has_one :ensemble
  has_one :performance_set_instrument

  validates :email_body, presence: true
  validates :email_title, presence: true
  validates :user, presence: true

  has_many :email_logs

  accepts_nested_attributes_for :email_logs
end
