class AddLocationToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :location, :string
  end
end

