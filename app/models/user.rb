class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :name, :username, :location, :email, :password, :password_confirmation
  has_many :reviews

geocoded_by :address || request.location         # can also be an IP address
after_validation :geocode          # auto-fetch coordinates

def address
	self.location
end

  ##validations##
end
