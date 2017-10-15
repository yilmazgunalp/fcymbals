# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'




	i =  0
	CSV.foreach('./db/cleaned_makers_at_swires.csv', headers: true, col_sep: ";") do |row|
		i += 1
	begin	
	m = Maker.new	
	row.each do |header,field|  
	field.downcase! unless field.nil?
	m.send((header+'=').to_sym,field)

	end
	m.save
	rescue

	puts "#{i}:" + row.to_s	

	end
	end

	