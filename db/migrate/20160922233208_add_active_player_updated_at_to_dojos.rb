class AddActivePlayerUpdatedAtToDojos < ActiveRecord::Migration[5.0]
  def change
    add_column :dojos, :active_player_updated_at, :datetime
  end
end
