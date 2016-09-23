class AddActivePlayerIdToDojos < ActiveRecord::Migration[5.0]
  def change
    add_column :dojos, :active_player_id, :integer
  end
end
