class ChangeDatatypeForRequest < ActiveRecord::Migration[5.0]
  def change
     remove_column :requests, :status, :string
     remove_column :requests, :issue, :string
     add_column :requests, :status, :integer
     add_column :requests, :issue, :integer
  end
end
