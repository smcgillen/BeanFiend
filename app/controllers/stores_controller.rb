class StoresController < ApplicationController
	def index

		ip = "208.185.23.206"
		@stores = Store.near(Geocoder.coordinates(params[:address]) || Geocoder.coordinates(ip), 1.00)
		@json = @stores.to_gmaps4rails
		if @stores.first == nil || @stores.size < 5
			begin
				if params[:wide_search]
					Store.wide_search(params[:address])
				else
					Store.add_stores(params[:address] || Geocoder.address(ip))
				end
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
