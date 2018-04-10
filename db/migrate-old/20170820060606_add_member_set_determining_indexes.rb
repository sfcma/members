class AddMemberSetDeterminingIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :member_instruments, :member_id
    add_index :performance_sets, :end_date
    add_index :performance_sets, [:end_date, :ensemble_id], :name => :index_end_date_and_ensemble_id
  end
end
