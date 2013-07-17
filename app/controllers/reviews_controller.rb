class ReviewsController < ApplicationController
	def index

	end

	def new
		@store = Store.find(params[:store_id])
		@review = Review.new
	end

	def create
		@review = Review.new(params[:review])
		if @review.save
			redirect_to Store.find(@review.store.id)
		else
			render :new
		end
	end	
end