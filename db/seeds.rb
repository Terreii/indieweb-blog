# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Post.create([
  {
    title: 'usePouchDB - React Hooks for PouchDB',
    published_at: DateTime.parse('2020-07-10T14:20:00+00:00'),
    body: %{
    <p>Last fall I (finally) read CouchDB’s Documentation completely. And since I’ve read its security and design documents parts, I can’t get the idea out of my head, that all you need for a CRUD web app is a front end with React + React-Hooks + PouchDB hosted on a static file host. And CouchDB paired with some serverless functions (function as a service) as the backend end.</p>

    <p>So I written those React hooks and published them as usePouchDB to npm. This post will go into some design decisions and how I think they could be used. For a tutorial and API docs please visit <a href="https://christopher-astfalk.de/use-pouchdb/">https://christopher-astfalk.de/use-pouchdb/</a>.</p>

    <p>If you use a service-worker, then your CRUD web app becomes, with some small changes, even offline first! Create-react-app for example, comes with a service-worker out of the box.</p>
    }
  },
  {
    title: 'Why did I write a Blog engine',
    body: %{
    <p>I wanted to tune my Ruby and Ruby on Rails knowlage</p>
    <p>There are also other aspects:</p>
    <ul>
      <li>Todo: find them</li>
    </ul>
    }
  }
])
