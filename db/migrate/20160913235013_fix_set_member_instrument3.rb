class FixSetMemberInstrument3 < ActiveRecord::Migration[5.0]
  def change
    rename_column :set_member_instruments, :set_member_id, :member_set_id
  end
end
