class CreateSetMemberInstruments < ActiveRecord::Migration[5.0]
  def change
    create_table :set_member_instruments do |t|
      t.references :performance_set, foreign_key: true
      t.references :member_instrument, foreign_key: true

      t.timestamps
    end
  end
end
