class CreateAmmos < ActiveRecord::Migration[5.0]
  def change
    create_table :ammos do |t|
      t.string :position
      t.belongs_to :dojo, index: true

      t.timestamps
    end
  end
end
