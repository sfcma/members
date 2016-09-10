class CreatePerformanceSets < ActiveRecord::Migration[5.0]
  def change
    create_table :performance_sets do |t|
      t.references :performance, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
