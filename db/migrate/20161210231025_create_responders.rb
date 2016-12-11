class CreateResponders < ActiveRecord::Migration[5.0]
  def change
    create_table :responders do |t|
      t.string :fname
      t.string :lname
      t.string :phone
      t.string :email
      t.string :barNum
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
