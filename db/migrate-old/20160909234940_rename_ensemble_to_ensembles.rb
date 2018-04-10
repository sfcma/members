class RenameEnsembleToEnsembles < ActiveRecord::Migration[5.0]
  def change
    rename_table :ensemble, :ensembles
  end
end
