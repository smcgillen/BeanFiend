require 'gmaps4rails'
require 'rake'
require 'dotenv-rails'
Dotenv.load

search = "coffee -starbucks -dunkin -manger -hagen -daz"

namespace :defaultuser do 
	task :addCafes => :environment do 

		coffee = Gmaps4rails.places_for_address('NYC, NY', ENV['GOOG_API_KEY'], "#{search}" , 7500)
		coffee.each do |store|
			new_store = Store.new
			new_store.address = store[:vicinity]
			new_store.name = store[:name]
			new_store.latitude = store[:lat]	
			new_store.longitude = store[:lng]
			new_store.gmaps = true
			new_store.save
		end
		# coffee = Gmaps4rails.places_for_address("Queens NY", ENV['GOOG_API_KEY'], "#{search}" , 7500)

		10.times do
			just_added = []
			coffee.each do |search_source|
				sleep(0.75)
				puts "starting new search"
				new_results = Gmaps4rails.places_for_address("#{search_source[:vicinity]}", ENV['GOOG_API_KEY'], "#{search}" , 2000)
				new_results.each do |cafe|
					unless Store.where(latitude: cafe[:lat], longitude: cafe[:lng]).first
						new_cafe = Store.new
						new_cafe.address = cafe[:vicinity]
						new_cafe.name = cafe[:name]
						new_cafe.latitude = cafe[:lat]
						new_cafe.longitude = cafe[:lng]
						new_cafe.gmaps = true
						new_cafe.save
						just_added << cafe
					end
				end
			end
			coffee = just_added
		end
	end
end