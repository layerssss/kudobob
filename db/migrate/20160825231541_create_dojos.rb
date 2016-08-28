class CreateDojos < ActiveRecord::Migration[5.0]
  def change
    create_table :dojos do |t|

      t.timestamps
    end
  end
end
