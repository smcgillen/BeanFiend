class StoresController < ApplicationController
	def index
		ip = ""
		if request.location == "127.0.0.1"
			ip = "208.185.23.206"
		else
			ip = request.location
		end
		@json = Store.near(Geocoder.coordinates(ip), 1.00).to_gmaps4rails
		@stores = Store.near(Geocoder.coordinates(ip), 1.00)
		if @store == nil
			Store.add_stores(Geocoder.address(ip))
			@stores = Store.near(Geocoder.coordinates(ip), 1.00)
		end
	end

	def search
		Store.add_stores(params[:address])
		@userLocation = params[:address]
		render 'index'
	end

	def show
		@store = Store.find(params[:id])
		@json = @store.to_gmaps4rails
	end
end
