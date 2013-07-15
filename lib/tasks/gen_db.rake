require 'gmaps4rails'
require 'rake'

search = "coffee -starbucks -dunkin -manger -hagen -daz"

namespace :defaultuser do 
	task :addLocations => :environment do 

		# coffee = Gmaps4rails.places_for_address('NYC', 'AIzaSyDKrFpvIO7kxBBca_t9X8g5LwMCIN-5p1I', "#{search}" , 1000)
		# last = ""
		# coffee.each do |cafe|
		# 	new_cafe = Location.new
		# 	new_cafe.vicinity = cafe[:vicinity]
		# 	new_cafe.name = cafe[:name]
		# 	new_cafe.latitude = cafe[:lat]
		# 	new_cafe.longitude = cafe[:lng]
		# 	new_cafe.gmaps = true
		# 	new_cafe.save
		# end
		coffee = Gmaps4rails.places_for_address("Queens NY", "AIzaSyDKrFpvIO7kxBBca_t9X8g5LwMCIN-5p1I", "#{search}" , 7500)

		10.times do
			just_added = []
			coffee.each do |search_source|
				sleep(1.0)
				puts "starting new search"
				new_results = Gmaps4rails.places_for_address("#{search_source[:vicinity]}", "AIzaSyDKrFpvIO7kxBBca_t9X8g5LwMCIN-5p1I", "#{search}" , 7500)
				new_results.each do |cafe|
					new_cafe = Location.find_or_create_by_vicinity(cafe[:vicinity])
					new_cafe.vicinity = cafe[:vicinity]
					new_cafe.name = cafe[:name]
					new_cafe.latitude = cafe[:lat]
					new_cafe.longitude = cafe[:lng]
					new_cafe.gmaps = true
					new_cafe.save
					just_added << cafe
				end
			end
			coffee = just_added
		end
	end
end