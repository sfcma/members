class CreateActionLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :action_logs do |t|
      t.references :member, foreign_key: true
      t.references :user, foreign_key: true
      t.string :action

      t.timestamps
    end
  end
end
