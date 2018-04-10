class CreateOptInMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :opt_in_messages do |t|
      t.string :message

      t.timestamps
    end
  end
end
