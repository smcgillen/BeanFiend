class WelcomeController < ApplicationController
	def index
		Gmaps4rails.geocode("Caroline")
	end
end