class CreateAbsences < ActiveRecord::Migration[5.0]
  def change
    create_table :absences do |t|
      t.references :member, foreign_key: true
      t.references :performanceset, foreign_key: true
      t.date :date
      t.boolean :planned
      t.boolean :sub_found

      t.timestamps
    end
  end
end
