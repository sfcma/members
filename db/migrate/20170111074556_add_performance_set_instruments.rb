class AddPerformanceSetInstruments < ActiveRecord::Migration[5.0]
  def change
    create_table :performance_set_instruments, :force => true do |t|
      t.references :performance_set, foreign_key: true
      t.string :instrument, null: false
      t.integer :limit

      t.timestamps
    end
  end
end
