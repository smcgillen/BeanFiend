class CreateReviews < ActiveRecord::Migration
  def up
  	create_table :reviews do |t|
  		t.string :title
  		t.string :text
  		t.timestamps
  	end
  end

  def down
  	drop_table :reviews
  end
end
