class ReviewsController < ApplicationController

	def new
		@store = Store.find(params[:store_id])
		@review = Review.new
	end

	def create
		@store = Store.find(params[:review][:store_id])
		@review = Review.new(params[:review])
		if @review.save
			redirect_to @store
		else
			render :new
		end
	end	
end