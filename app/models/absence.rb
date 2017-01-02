class Absence < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid
  belongs_to :member
  belongs_to :performance_set_date, required: true

  validate do |absence|
    errors[:base] << "<h3>That email address doesn't have a member attached to it! Please enter the email address you gave us, or contact info@sfcivicsymphony.org for help.</h3>".html_safe if member.blank?
  end
end
