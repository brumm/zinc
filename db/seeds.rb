# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Roles
Role.create name: :admin
Role.create name: :owner
Role.create name: :mod

# User
admin = User.create username: "brumm", email: "philipp@railslove.com", password: "denkdichfrei"
admin.add_role(:admin)
