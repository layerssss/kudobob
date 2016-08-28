class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.belongs_to :dojo, index: true

      t.timestamps
    end
  end
end
