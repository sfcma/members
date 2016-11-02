# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
User.create!(
  email: 'aoeu@gmail.com',
  password: 'Password123',
)

ensemble = Ensemble.create!(
  name: 'Symphony1',
  description: 'First symphony',
)

performance = PerformanceSet.create!(
  ensemble: ensemble,
  start_date: Date.new(2016, 1, 1),
  end_date: Date.new(2016, 4, 1),
  name: 'Symphony1-2016-01',
)

member = Member.create!(
  first_name: 'Terry',
  last_name: 'Pratchett',
  address_1: '123 Castro St',
  city: 'San Francisco',
  state: 'CA',
  zip: '94103',
  phone_1: '1234567890',
  phone_1_type: 'Work',
  email_1: 'terry@example.com',
)

instrument = MemberInstrument.create!(
  member: member,
  instrument: 'Cello',
)

member_set = MemberSet.create!(
  member: member,
  performance_set: performance,
  set_status: :playing,
)

SetMemberInstrument.create!(
  member_set: member_set,
  member_instrument: instrument,
)
