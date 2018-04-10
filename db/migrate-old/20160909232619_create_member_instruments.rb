class CreateMemberInstruments < ActiveRecord::Migration[5.0]
  def change
    create_table :member_instruments do |t|
      t.integer :member_id
      t.string :instrument

      t.timestamps
    end
  end
end
