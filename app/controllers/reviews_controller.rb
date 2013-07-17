class ReviewsController < ApplicationController
	def index

	end

	def new
		@store = Store.find(params[:store_id])
		@review = Review.new
	end

	def create

	end
end