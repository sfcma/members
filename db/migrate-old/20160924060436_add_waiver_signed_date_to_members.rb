class AddWaiverSignedDateToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :waiver_signed, :date
  end
end
