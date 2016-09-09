class AddPublicToScripts < ActiveRecord::Migration[5.0]
  def change
    add_column :scripts, :public, :boolean
  end
end
