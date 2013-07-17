class Store < ActiveRecord::Base
	acts_as_gmappable
	def gmaps4rails_address
		#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
  		"#{self.address}"
	end

	def coordinates
		return [self.latitude, self.longitude]
	end

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
  
	  def gmaps4rails_title
	    "#{self.name}"
	  end

	has_many :reviews

	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode  # auto-fetch address

	def self.add_stores(address)
		local_stores=Gmaps4rails.places_for_address(address, ENV["GOOG_API_KEY"], "coffee", 10000)
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
	end

	def self.wide_search(address)
		search_radius = 7000
		local_stores=Gmaps4rails.places_for_address(address, ENV["GOOG_API_KEY"], "coffee", search_radius)
		while local_stores.first == nil || local_stores.count < 8
			sleep(0.70)
			search_radius+=1000
			local_stores=Gmaps4rails.places_for_address(address, ENV["GOOG_API_KEY"], "coffee", search_radius)
		end
		local_stores.each do |store|
			sleep(0.70)
			add_stores(store[:vicinity])
		end
	end
end