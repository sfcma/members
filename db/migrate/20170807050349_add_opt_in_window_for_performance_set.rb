class AddOptInWindowForPerformanceSet < ActiveRecord::Migration[5.0]
  def change
    add_column :performance_sets, :opt_in_start_date, :datetime
    add_column :performance_sets, :opt_in_end_date, :datetime
  end
end
