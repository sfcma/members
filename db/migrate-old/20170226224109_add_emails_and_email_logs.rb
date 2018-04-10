class AddEmailsAndEmailLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :emails, :force => true do |t|
      t.text :email_body, null: false
      t.string :email_title, null: false
      t.references :user, foreign_key: true, null: false
      t.references :performance_set, null: true
      t.references :ensemble, null: true
      t.references :performance_set_instrument, null: true
      t.string :status, null: true

      t.timestamps
    end

    create_table :email_logs, :force => true do |t|
      t.references :email, foreign_key: true, null: false
      t.references :member, foreign_key: true, null: false

      t.timestamps
    end
  end
end
