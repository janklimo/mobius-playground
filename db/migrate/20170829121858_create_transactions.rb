class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :sender, references: :users, index: true
      t.references :recipient, references: :users, index: true
      t.float :num_credits, null: false
    end

    add_foreign_key :transactions, :users, column: :sender_id
    add_foreign_key :transactions, :users, column: :recipient_id
  end
end
