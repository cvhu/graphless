# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Model.create([{name: 'string', data_type: 'string'}, {name: 'integer', data_type: 'integer'}, {name: 'float', data_type: 'float'}, {name: 'text', data_type: 'text'}, {name: 'currency', data_type: 'currency'}, {name: 'url', data_type: 'url'}])