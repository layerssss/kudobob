class AddDiedAtToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :died_at, :datetime
  end
end
