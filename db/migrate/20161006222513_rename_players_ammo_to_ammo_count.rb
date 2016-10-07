class RenamePlayersAmmoToAmmoCount < ActiveRecord::Migration[5.0]
  def change
    rename_column :players, :ammo, :ammo_count
  end
end
