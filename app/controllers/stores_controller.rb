class StoresController < ApplicationController
	def index

		ip = "208.185.23.206"
		@stores = Store.near(Geocoder.coordinates(params[:address]) || Geocoder.coordinates(ip), 1.00)
		@json = @stores.to_gmaps4rails
		if @store == nil
			begin
				Store.wide_search(params[:address] || Geocoder.address(ip))
			rescue Exception => e
				puts e
			end
			@stores = Store.near(Geocoder.coordinates(params[:address]) || Geocoder.coordinates(ip), 1.00)
		end
	end

	def show
		@store = Store.find(params[:id])
		@json = @store.to_gmaps4rails
	end
end
