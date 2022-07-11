# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

tags = Tag.create([
  { name: Faker::Types.rb_string.downcase },
  { name: Faker::Types.rb_string.downcase },
  { name: Faker::Types.rb_string.downcase }
])

first_title = Faker::Books::Dune.quote
second_title = Faker::Books::Dune.quote
draft_title = Faker::Kpop.girl_groups

Post.create([
  {
    title: first_title,
    slug: Post.string_to_slug(first_title),
    tags: tags,
    published_at: DateTime.parse('2020-07-10T14:20:00+00:00'),
    summary: Faker::Lorem.paragraph,
    body: "<p>#{Faker::Lorem.paragraphs(number: 6).join '</p><p>'}</p>"
  },
  {
    title: second_title,
    slug: Post.string_to_slug(second_title),
    tags: [tags.first],
    published_at: DateTime.parse('2020-09-11T14:20:00+00:00'),
    summary: Faker::Lorem.paragraph,
    body: "<p>#{Faker::Lorem.paragraphs(number: 6).join '</p><p>'}</p>"
  },
  {
    title: draft_title,
    slug: Post.string_to_slug(draft_title),
    tags: [tags.first],
    body: "<p>#{Faker::Lorem.paragraphs.join '</p><p>'}</p>"
  }
])

Bookmark.create([
  {
    title: "IndieWeb Bookmarks",
    url: "https://indieweb.org/bookmark"
  },
  {
    title: "IndieWeb h-entry",
    url: "https://indieweb.org/h-entry"
  }
])
