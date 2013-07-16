class StoresController < ApplicationController
	def index
		if params[:query]
			local_stores=Gmaps4rails.places_for_address(params[:query].to_s, ENV["GOOG_API_KEY"], "coffee cafe -Starbucks -Dunkin -Donuts -Hagen -Daz -McDonalds -Pret",  5000)
			local_stores.each do |store|
				unless Store.where(latitude: store[:lat], longitude: store[:lng]).first
					new_store = Store.new
					new_store.name = store[:name]
					new_store.address = store[:vicinity]
					new_store.latitude = store[:lat]
					new_store.longitude = store[:lng]
					new_store.gmaps = true
					new_store.save
				end
			end
			@json = Store.near(Geocoder.coordinates(params[:query]), 1.00).to_gmaps4rails
			@stores = Store.near(Geocoder.coordinates(params[:query]), 1.00)
			@userLocation = Geocoder.coordinates(params[:query])
		else 
			@json = Store.near(Geocoder.coordinates(current_user.address || request.location), 1.00).to_gmaps4rails
			@stores = Store.near(Geocoder.coordinates(current_user.address || request.location), 1.00)
		end
	end
end