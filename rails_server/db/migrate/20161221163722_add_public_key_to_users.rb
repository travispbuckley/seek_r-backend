class AddPublicKeyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :public_key_n, :string
    add_column :users, :public_key_e, :string
    add_column :messages, :your_message, :string
  end
end
