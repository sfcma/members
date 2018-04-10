class ConvertWaiverSignedDateToDatetime < ActiveRecord::Migration[5.0]
  def change
    change_column :members, :waiver_signed, :datetime
  end
end
