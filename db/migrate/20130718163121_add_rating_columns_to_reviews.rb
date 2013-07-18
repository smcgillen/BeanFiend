class AddRatingColumnsToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews, :noise, :integer, default: 5, limit: 10.0
 	add_column :reviews, :people, :integer, default: 5, limit: 10.0
 	add_column :reviews, :wifi, :integer, default: 5, limit: 10.0
 	add_column :reviews, :price, :integer, default: 5, limit: 10.0
 	add_column :reviews, :coffee, :integer, default: 5, limit: 10.0
  end
end
