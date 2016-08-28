class AddKegToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :keg, :string
  end
end
