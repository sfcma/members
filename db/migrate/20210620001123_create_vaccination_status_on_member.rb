class CreateVaccinationStatusOnMember < ActiveRecord::Migration[5.0]
    def change
      add_column :members, :vaccination_status, :string
    end
  end
  