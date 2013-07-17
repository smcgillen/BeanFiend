class ReviewsController < ApplicationController
	def index

	end

	def new
		@store = Store.find(params[:store_id])
		@review = Review.new(store: @store)
	end

	def create
		@review = Review.new(params[:review])
		if @review.save
			redirect_to @review
		else
			render :new
		end
	end	
end