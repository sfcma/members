class AddMemberSetStatusId < ActiveRecord::Migration[5.0]
  def change
    add_column :member_sets, :set_status_id, :integer, default: 0, null: false
    add_index :member_sets, :set_status_id
  end
end
