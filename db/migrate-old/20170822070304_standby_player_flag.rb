class StandbyPlayerFlag < ActiveRecord::Migration[5.0]
  def change
    add_column :member_sets, :standby_player, :boolean, default: false
  end
end
