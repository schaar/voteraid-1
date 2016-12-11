class AddCityToResponder < ActiveRecord::Migration[5.0]
  def change
    add_column :responders, :city, :string
  end
end
