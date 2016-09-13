class ModifyMembersFirstContact < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :initial_date, :datetime
  end
end
