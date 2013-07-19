class Store < ActiveRecord::Base

	## relation to reviews ##
	has_many :reviews

	## enables gmaps mapping through gmaps4rails ##
	acts_as_gmappable

	## enables geocoding of store coordinates ##
	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode  # auto-fetch address

	## enables pagination ##
	self.per_page = 10

	## allows gmaps4rails to find the address of a store ##
	def gmaps4rails_address
		#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
  		"#{self.address}"
	end

	## defines the content of gmaps popup windows ##
	def gmaps4rails_infowindow
		if self.reviews == nil
			count = 0
		else
			count = self.reviews.count
		end
		"<a href = '/stores/#{(self.id)}'> #{self.name} </a>
		<p>#{self.address}</p>
		<p>#{count} reviews</p>"
  	end
  
  	## defines title for gmaps popup windows ##
	def gmaps4rails_title
		"#{self.name}"
	end

	## returns coordinates for Geocoder ##
	def coordinates
		return [self.latitude, self.longitude]
	end

	## adds up to 20 stores when a location is entered ##
	def self.add_stores(address)
		local_stores=Gmaps4rails.places_for_address(address, ENV["GOOG_API_KEY"], "coffee", 1000)
		local_stores.each do |store|
			unless Store.where(latitude: store[:lat], longitude: store[:lng]).first || ENV["EXCLUDE"].include?(store[:name].gsub("'", "")) || store[:name] == "Dunkin' Donuts"
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

	## searches a wider area than add_stores, uses found locations to search for more stores ##
	def self.wide_search(address)
		search_radius = 7000
		local_stores=Gmaps4rails.places_for_address(address, ENV["GOOG_API_KEY"], "coffee", search_radius)
		while local_stores.first == nil || local_stores.count < 8
			search_radius+=1000
			local_stores=Gmaps4rails.places_for_address(address, ENV["GOOG_API_KEY"], "coffee", search_radius)
			sleep(1.0)
		end
		local_stores.each do |store|
			add_stores(store[:vicinity])
			sleep(1.0)
		end
	end
end