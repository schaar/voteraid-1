class AddAddressToResponder < ActiveRecord::Migration[5.0]
  def change
    add_column :responders, :address, :string
  end
end
