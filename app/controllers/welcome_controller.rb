class WelcomeController < ApplicationController
	def index
		@json = Store.all
	end
end