class User < ActiveRecord::Base

	## setup Users for devise ##
	devise :database_authenticatable, 
		:registerable,
      	:recoverable, 
      	:rememberable, 
      	:trackable, 
      	:validatable

      ## allows mass assignment of values ##
	attr_accessible :name, 
		:username, 
		:location, 
		:email, 
		:password, 
		:address, 
		:password_confirmation, 
		:remember_me, 
		:subscriptions_attributes
  
  	## relation to reviews ##
	has_many :reviews

	## setup for geocoding and reverse geocoding ##
	geocoded_by :address || request.ip         # can also be an IP address
	after_validation :geocode          # auto-fetch coordinates

	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode  # auto-fetch address


	## returns user address ##
	def address
		Geocoder.address([self.latitude, self.longitude])
	end


  	## devise deals with validations of user input ##
end
