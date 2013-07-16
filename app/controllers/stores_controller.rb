class StoresController < ApplicationController
	def index

		ip = "208.185.23.206"
		@stores = Store.near(Geocoder.coordinates(params[:address]) || Geocoder.coordinates(ip), 1.00)
		@json = @stores.to_gmaps4rails
		if @store == nil
			Store.add_stores(params[:address] || Geocoder.address(ip))
			@stores = Store.near(Geocoder.coordinates(params[:address]) || Geocoder.coordinates(ip), 1.00)
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
