# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

Post.create([
  {
    title: Faker::Books::Dune.quote,
    published_at: DateTime.parse('2020-07-10T14:20:00+00:00'),
    body: "<p>#{Faker::Lorem.paragraphs(number: 6).join '</p><p>'}</p>"
  },
  {
    title: Faker::Kpop.girl_groups,
    body: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
  }
])
