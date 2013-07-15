class Locations < ActiveRecord::Migration
  def up
  	create_table :locations do |t|
  		t.float :latitude
  		t.float :longitute
  		t.boolean :gmaps
  	end
  end

  def down
  	drop_table :locations
  end
end
