class AllowMultipleInstrumentsInEmail < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :instruments, :string
  end
end
