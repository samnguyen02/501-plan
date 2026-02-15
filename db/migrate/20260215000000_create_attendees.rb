class CreateAttendees < ActiveRecord::Migration[8.0]
  def change
    create_table :attendees do |t|
      t.string :name, null: false
      t.string :phone_number
      t.string :email, null: false

      t.timestamps
    end
  end
end
