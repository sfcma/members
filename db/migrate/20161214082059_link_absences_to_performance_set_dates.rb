class LinkAbsencesToPerformanceSetDates < ActiveRecord::Migration[5.0]
  def change
    remove_column :absences, :performance_set_id
    add_column :absences, :performance_set_date_id, :integer
  end
end
