class AddPerformancePiece < ActiveRecord::Migration[5.0]
  def change
    create_table :performance_pieces do |t|
      t.references :performance_set, foreign_key: true
      t.string :title, null: false
      t.string :composer

      t.timestamps
    end

    create_table :performance_pieces_members do |t|
      t.references :performance_piece, foreign_key: true
      t.references :member, foreign_key: true
      t.string :instrument, null: false
      t.string :member_piece_status, null: false

      t.timestamps
    end
  end
end
