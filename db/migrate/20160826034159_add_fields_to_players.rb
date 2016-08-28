class AddFieldsToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :position, :string
    add_column :players, :direction, :integer
    add_column :players, :ammo, :integer, default: 0
  end
end
