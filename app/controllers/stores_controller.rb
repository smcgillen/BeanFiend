class StoresController < ApplicationController
	def index

		ip = "208.185.23.206"
		@stores = Store.near(Geocoder.coordinates(params[:address]) || Geocoder.coordinates(ip), 1.00).paginate(:page => params[:page], :per_page => 10)
		
		if @stores.first == nil || @stores.size < 5 
			begin
				Store.add_stores(params[:address] || Geocoder.address(ip))
			rescue Exception => e
				puts e
			end
			@stores = Store.near(Geocoder.coordinates(params[:address]) || Geocoder.coordinates(ip), 1.00).paginate(:page => params[:page], :per_page => 10)
		end
		@json =  Store.near(Geocoder.coordinates(params[:address]) || Geocoder.coordinates(ip), 1.00).to_gmaps4rails
		if params[:wide_search]
			begin
				Store.wide_search(params[:address])
			rescue Exception => e
				puts e
			end
			@stores = Store.near(Geocoder.coordinates(params[:address]) || Geocoder.coordinates(ip), 5.00).paginate(:page => params[:page], :per_page => 10)
			@json =  Store.near(Geocoder.coordinates(params[:address]) || Geocoder.coordinates(ip), 5.00).to_gmaps4rails
		end
	end

	def show
		@store = Store.find(params[:id])
		@json = @store.to_gmaps4rails
	end
end
