class StoresController < ApplicationController
	def index
		@json = Store.near(Geocoder.coordinates(current_user.address || request.location), 1.00).to_gmaps4rails
		@stores = Store.near(Geocoder.coordinates(current_user.address || request.location), 1.00)
	end

	def search
		params[:store] = nil if params[:store] == ""
		local_stores=Gmaps4rails.places_for_address(params[:query].to_s, ENV["GOOG_API_KEY"], (params[:store] || ENV["SEARCH"]), 6000)
		local_stores.each do |store|
			unless Store.where(latitude: store[:lat], longitude: store[:lng]).first || ENV["EXCLUDE"].include?(store[:name])
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
		render 'index'
	end

	def show
		@store = Store.find(params[:id])
		@json = @store.to_gmaps4rails
	end


end
