search = "coffee -starbucks -dunkin -manger -hagen -daz"

namespace :defaultuser do 
	task :addCafes => :environment do 

		address = "229 2nd Ave. NYC, NY"

	
		search_radius = 1000
		local_stores=Gmaps4rails.places_for_address(address, ENV["GOOG_API_KEY"], "coffee", search_radius)
		while local_stores.first == nil || local_stores.count < 8
			search_radius+=1000
			local_stores=Gmaps4rails.places_for_address(address, ENV["GOOG_API_KEY"], "coffee", search_radius)
			sleep(1.0)
		end
		while true
			just_added = []
			local_stores.each do |center|
				puts "Searching location #{center[:vicinity]}"
				stores=Gmaps4rails.places_for_address(center[:vicinity], ENV["GOOG_API_KEY"], "coffee", 2000)
				stores.each do |store|
					unless Store.where(latitude: store[:lat], longitude: store[:lng]).first || ENV["EXCLUDE"].include?(store[:name]) || store[:name] == "Dunkin' Donuts"
						puts "adding store"
						new_store = Store.new
						new_store.name = store[:name]
						new_store.address = store[:vicinity]
						new_store.latitude = store[:lat]
						new_store.longitude = store[:lng]
						new_store.gmaps = true
						new_store.save
						just_added << store
					end
				end
				local_stores = just_added
				sleep(1.0)
			end
		end
	end
end