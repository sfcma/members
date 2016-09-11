class RenamePerformanceColumnToEnsemble < ActiveRecord::Migration[5.0]
  def change
    rename_column :performance_sets, :performance_id, :ensemble_id
  end
end
