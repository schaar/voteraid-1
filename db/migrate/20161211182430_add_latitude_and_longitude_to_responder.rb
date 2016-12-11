class AddLatitudeAndLongitudeToResponder < ActiveRecord::Migration[5.0]
  def change
    add_column :responders, :latitude, :float
    add_column :responders, :longitude, :float
  end
end
