class RenamePerformanceToEnsemble < ActiveRecord::Migration[5.0]
  def change
    rename_table :performances, :ensemble
  end
end
