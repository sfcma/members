class AddGeneralInterestFlagsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :interested_in_large_ensemble_opportunities, :boolean, default: true
    add_column :members, :interested_in_chamber_opportunities, :boolean, default: true
    add_column :members, :unsubscribe_from_all_emails, :boolean, default: false
  end
end
