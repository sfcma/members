class CreateUserInstrumentEnsemblePermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_instrument_ensemble_permissions do |t|
      t.references :user, foreign_key: true
      t.references :user_instrument, foreign_key: true, index: { name: 'index_user_inst_ens_perms_on_user_instrument_id' }
      t.references :user_ensemble, foreign_key: true, index: { name: 'index_user_inst_ens_perms_on_user_ensemble_id' }

      t.timestamps
    end
  end
end
