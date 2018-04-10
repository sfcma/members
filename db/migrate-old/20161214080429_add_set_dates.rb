class AddSetDates < ActiveRecord::Migration[5.0]
  def change
    create_table :performance_set_dates do |t|
      t.references :performance_set, foreign_key: true, null: false
      t.date :date, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :performance_set_dates, :deleted_at
  end
end
