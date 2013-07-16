class StoresController < ApplicationController
	def index
		if params[:query]
			local_stores=Gmaps4rails.places_for_address(params[:query].to_s, ENV["GOOG_API_KEY"], "coffee, cafe -'starbucks' -'dunkin' -'manger' -'hagen' -'daz'", 2000)
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
		end
		@json = Store.all.to_gmaps4rails
		@stores = Store.all 
	end
end