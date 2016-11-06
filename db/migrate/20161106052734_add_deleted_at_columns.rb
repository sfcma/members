class AddDeletedAtColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :performance_pieces, :deleted_at, :datetime
    add_index :performance_pieces, :deleted_at

    add_column :performance_pieces_members, :deleted_at, :datetime
    add_index :performance_pieces_members, :deleted_at
  end
end
