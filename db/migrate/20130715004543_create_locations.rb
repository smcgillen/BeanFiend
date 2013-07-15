class CreateLocations < ActiveRecord::Migration
  def up
  	create_table :locations do |t|
  		t.string :name
  		t.string :vicinity
  		t.float :latitude
  		t.float :longitude
  		t.boolean :gmaps
  		t.timestamps
  	end
  end

  def down
  	drop_table :locations
  end
end
