class AddAliveToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :alive, :boolean, default: true
  end
end
