class Absence < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid
  belongs_to :member
  belongs_to :performance_set_date, required: true

  validates_uniqueness_of :member, scope: :performance_set_date, message: "An absence has already been submitted for this date."

  INSTRUMENTS_REQUIRING_SUBS = [
    'flute', 'b flat clarinet', 'bassoon', 'french horn', 'piccolo', 'trombone', 'percussion',
    'trumpet', 'oboe', 'alto saxophone', 'english horn', 'bass trombone', 'tuba', 'clarinet'
  ]

  validate do |absence|
    errors[:base] << "<h3>We could not find a member for that email address. Please enter the email address you gave us, or contact membership@sfcivicsymphony.org for help.</h3>".html_safe if member.blank?
  end
end
