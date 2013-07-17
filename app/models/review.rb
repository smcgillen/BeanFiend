class Review < ActiveRecord::Base
	belongs_to :store
	belongs_to :user
	attr_accessible :title, :text, :user, :store
end