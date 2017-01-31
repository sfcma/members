class Absence < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid
  belongs_to :member
  belongs_to :performance_set_date, required: true

  validates_uniqueness_of :member, scope: :performance_set_date

  INSTRUMENTS_REQUIRING_SUBS = [
    'flute', 'b flat clarinet', 'bassoon', 'french horn', 'piccolo', 'trombone', 'percussion',
    'trumpet', 'oboe', 'alto saxophone', 'english horn', 'bass trombone', 'tuba', 'clarinet'
  ]

  validate do |absence|
    errors[:base] << "<h3>That email address doesn't have a member attached to it! Please enter the email address you gave us, or contact membership@sfcivicsymphony.org for help.</h3>".html_safe if member.blank?
  end
end
