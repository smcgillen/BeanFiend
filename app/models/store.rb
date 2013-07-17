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
		"<a href = '/stores/#{(self.id)}'> #{self.name} </a> "
  	end
  
	  def gmaps4rails_title
	    "#{self.name}"
	  end

	has_many :reviews

	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode  # auto-fetch address

	def self.add_stores(user_address)
		local_stores=Gmaps4rails.places_for_address(user_address, ENV["GOOG_API_KEY"], (ENV['SEARCH']), 5000)
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
		local_stores=Gmaps4rails.places_for_address(address, ENV["GOOG_API_KEY"], (ENV['SEARCH']), search_radius)
		while local_stores.first == nil
			puts "no stores found"
			sleep(0.75)
			search_radius+=1000
			local_stores=Gmaps4rails.places_for_address(address, ENV["GOOG_API_KEY"], (ENV['SEARCH']), search_radius)
			return false if search_radius == 10000
		end
		local_stores.each do |store|
			sleep(0.75)
			add_stores(store[:vicinity])
		end
	end
end