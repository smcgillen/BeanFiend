class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
      		:recoverable, :rememberable, :trackable, :validatable
	attr_accessible :name, :username, :location, :email, :password, :address, :password_confirmation, :remember_me, :subscriptions_attributes
  
	has_many :reviews

	geocoded_by :address || request.ip         # can also be an IP address
	after_validation :geocode          # auto-fetch coordinates

	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode  # auto-fetch address

	def address
		self.location
	end


  ##validations##
end
