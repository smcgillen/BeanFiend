class Review < ActiveRecord::Base
	belongs_to :store
	belongs_to :user
	attr_accessible :title, :text, :user_id, :store_id

	##Validations##
	validates :title, :text, presence: true

end