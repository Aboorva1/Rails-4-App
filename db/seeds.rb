# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

Student.destroy_all

50.times do
  Student.create!(
    name: Faker::Name.name,
    register_no: rand(1..60),
    maths: rand(30..99),
    science: rand(25..99)
  )
end
