class AddStandbyLimitToPerformanceSetInstruments < ActiveRecord::Migration[5.0]
  def change
    add_column :performance_set_instruments, :standby_limit, :integer, default: 0
  end
end
