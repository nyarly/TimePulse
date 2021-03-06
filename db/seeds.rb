# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

user = User.create!(:login => 'admin',
                     :name => "Admin",
                     :email => "admin@timepulse.io",
                     :password => 'foobar',
                     :password_confirmation => 'foobar')
user.admin = true
user.save
user.confirm!

Project.create(:name => 'root', :client => nil)