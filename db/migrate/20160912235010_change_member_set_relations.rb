class ChangeMemberSetRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :set_member do |t|
      t.references :performance_set, foreign_key: true
      t.references :member, foreign_key: true
      t.string :set_status, :string
      t.boolean :rotating, :boolean

      t.timestamps
    end
  end
end
