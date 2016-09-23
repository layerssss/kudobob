class AddColorToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :color, :string
  end
end
