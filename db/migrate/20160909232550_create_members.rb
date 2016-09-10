class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone_1
      t.string :phone_1_type
      t.string :phone_2
      t.string :phone_2_type
      t.string :email_1
      t.string :email_2
      t.string :emergency_name
      t.string :emergency_relation
      t.string :emergency_phone
      t.string :playing_status

      t.timestamps
    end
  end
end
