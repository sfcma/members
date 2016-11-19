require 'faker'

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

ensemble1 = Ensemble.create!(
  name: 'San Francisco String Ensemble',
  description: 'First ensemble',
)

ensemble2 = Ensemble.create!(
  name: 'Oakland Civic Orchestra',
  description: 'Second ensemble',
)

ensemble3 = Ensemble.create!(
  name: 'San Jose Band',
  description: 'Third ensemble',
)

performance1 = PerformanceSet.create!(
  ensemble: ensemble1,
  start_date: Date.new(2016, 1, 1),
  end_date: Date.new(2016, 4, 1),
  name: 'SF String Ensemble Winter 2016',
)

performance2 = PerformanceSet.create!(
  ensemble: ensemble1,
  start_date: Date.new(2016, 5, 1),
  end_date: Date.new(2016, 8, 1),
  name: 'SF String Ensemble Summer 2016',
)

performance3 = PerformanceSet.create!(
  ensemble: ensemble1,
  start_date: Date.new(2016, 10, 1),
  end_date: Date.new(2016, 12, 1),
  name: 'SF String Ensemble Fall 2016',
)

performance4 = PerformanceSet.create!(
  ensemble: ensemble2,
  start_date: Date.new(2016, 1, 1),
  end_date: Date.new(2016, 4, 1),
  name: 'Oakland Civic Winter 2016',
)

performance5 = PerformanceSet.create!(
  ensemble: ensemble2,
  start_date: Date.new(2016, 5, 1),
  end_date: Date.new(2016, 8, 1),
  name: 'Oakland Civic Summer 2016',
)

performance6 = PerformanceSet.create!(
  ensemble: ensemble2,
  start_date: Date.new(2016, 9, 1),
  end_date: Date.new(2016, 12, 1),
  name: 'Oakland Civic Fall 2016',
)

performance7 = PerformanceSet.create!(
  ensemble: ensemble3,
  start_date: Date.new(2016, 1, 1),
  end_date: Date.new(2016, 4, 1),
  name: 'San Jose Winter 2016',
)

performance8 = PerformanceSet.create!(
  ensemble: ensemble3,
  start_date: Date.new(2016, 5, 1),
  end_date: Date.new(2016, 8, 1),
  name: 'San Jose Summer 2016',
)

performance9 = PerformanceSet.create!(
  ensemble: ensemble3,
  start_date: Date.new(2016, 9, 1),
  end_date: Date.new(2016, 12, 1),
  name: 'San Jose Fall 2016',
)

performances = [performance1, performance2, performance3, performance4, performance5, performance6, performance7, performance8, performance9]
instruments = ['Flute', 'Clarinet', 'Oboe', 'Cello', 'Violin', 'Viola', 'Cello', 'Trumpet', 'Trombone']

50.times do
  member = Member.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address_1: Faker::Address.street_address,
    city: Faker::Address.city,
    state: 'CA',
    zip: Faker::Address.zip,
    phone_1: Faker::PhoneNumber.phone_number,
    phone_1_type: 'Work',
    email_1: Faker::Internet.email,
  )

  instrument = MemberInstrument.create!(
    member: member,
    instrument: instruments.sample,
  )

  perfID = rand(performances.length - 3)
  x = rand(5)
  x.times do
    member_set = MemberSet.create!(
      member: member,
      performance_set: performances[perfID],
      set_status: :playing,
    )

    SetMemberInstrument.create!(
      member_set: member_set,
      member_instrument: instrument,
    )

    perfID += 1
  end
end
