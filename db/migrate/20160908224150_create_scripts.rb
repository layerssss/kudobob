class CreateScripts < ActiveRecord::Migration[5.0]
  def change
    create_table :scripts do |t|
      t.belongs_to :user, index: true
      t.text :content

      t.timestamps
    end
  end
end
