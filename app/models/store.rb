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
		"<a href = 'store_path(#{self.id})'> #{self.name} </a> "
  	end
  
	  def gmaps4rails_title
	    "#{self.name}"
	  end

	has_many :reviews

	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode  # auto-fetch address

end