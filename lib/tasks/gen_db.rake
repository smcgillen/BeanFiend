require 'gmaps4rails'
require 'rake'
require 'dotenv-rails'
Dotenv.load

search = "coffee -starbucks -dunkin -manger -hagen -daz"

namespace :defaultuser do 
	task :addCafes => :environment do 

		coffee = Gmaps4rails.places_for_address('NYC', "AIzaSyCFMojxaL0VQkVYtw7Sj4mIl484FV0U0CQ", "#{search}" , 1000)
		coffee.each do |cafe|
			new_cafe = Cafe.new
			new_cafe.vicinity = cafe[:vicinity]
			new_cafe.name = cafe[:name]
			new_cafe.latitude = cafe[:lat]
			new_cafe.longitude = cafe[:lng]
			new_cafe.gmaps = true
			new_cafe.save
		end


		10.times do
			just_added = []
			coffee.each do |search_source|
				sleep(1.0)
				puts "starting new search"
				new_results = Gmaps4rails.places_for_address("#{search_source[:vicinity]}", "AIzaSyCFMojxaL0VQkVYtw7Sj4mIl484FV0U0CQ", "#{search}" , 7500)
				new_results.each do |cafe|
					new_cafe = Cafe.find_or_create_by_vicinity(cafe[:vicinity])
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