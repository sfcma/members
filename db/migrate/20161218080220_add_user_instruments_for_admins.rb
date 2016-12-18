class AddUserInstrumentsForAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :user_instruments do |t|
      t.references :user, foreign_key: true, null: false
      t.string :instrument, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :user_instruments, :instrument

    create_table :user_ensembles do |t|
      t.references :user, foreign_key: true, null: false
      t.references :ensemble, foreign_key: true, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
