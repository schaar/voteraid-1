class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.string :phone
      t.string :status
      t.string :address
      t.string :issue
      t.string :poll
      t.string :desc
      t.references :responder

      t.timestamps
    end
  end
end
