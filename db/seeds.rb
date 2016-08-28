# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
Dojo.create!
if ENV['EMAIL']
  admin_user = User.create! email: ENV['EMAIL'], password: ENV['PASSWORD'] || 'password', admin: true
  puts "Created admin user:"
  puts ""
  puts "* email: #{admin_user.email}"
  puts "* password: #{admin_user.password}"
  puts ""
end
