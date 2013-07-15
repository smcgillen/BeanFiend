class CreateLocations < ActiveRecord::Migration
  def up
  	create_table :stores do |t|
  		t.string :name
  		t.string :vicinity
             t.string :address
  		t.float :latitude
  		t.float :longitude
  		t.boolean :gmaps
  		t.timestamps
  	end
  end

  def down
  	drop_table :stores
  end
end
