class AddTitleToScripts < ActiveRecord::Migration[5.0]
  def change
    add_column :scripts, :title, :string
  end
end
