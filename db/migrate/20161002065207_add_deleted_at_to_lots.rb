class AddDeletedAtToLots < ActiveRecord::Migration[5.0]
  def change
    add_column :absences, :deleted_at, :datetime
    add_index :absences, :deleted_at

    add_column :ensembles, :deleted_at, :datetime
    add_index :ensembles, :deleted_at

    add_column :member_instruments, :deleted_at, :datetime
    add_index :member_instruments, :deleted_at

    add_column :member_notes, :deleted_at, :datetime
    add_index :member_notes, :deleted_at

    add_column :member_sets, :deleted_at, :datetime
    add_index :member_sets, :deleted_at

    add_column :members, :deleted_at, :datetime
    add_index :members, :deleted_at

    add_column :performance_sets, :deleted_at, :datetime
    add_index :performance_sets, :deleted_at

    add_column :set_member_instruments, :deleted_at, :datetime
    add_index :set_member_instruments, :deleted_at

    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  end
end
