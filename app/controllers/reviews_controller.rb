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

	def show
		@review = Review.find(params[:id])
	end

	def edit
		@review = Review.find(params[:id])
		@store = @review.store
	end

	def update
		@review =  Review.find(params[:id])
		if @review.update_attributes(params[:review])
			redirect_to @review.store
		else
			render :edit
		end
	end

	def destroy
		store = Review.find(params[:id]).store
		Review.find(params[:id]).destroy
		redirect_to store
	end

end