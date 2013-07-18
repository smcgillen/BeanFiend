class ChangeReviewStringToText < ActiveRecord::Migration
  def up
  	change_column :reviews, :text, :text
  end

  def down
  	change_column :reviews, :text, :string
  end
end
