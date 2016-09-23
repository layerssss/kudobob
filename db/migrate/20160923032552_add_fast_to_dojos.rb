class AddFastToDojos < ActiveRecord::Migration[5.0]
  def change
    add_column :dojos, :fast, :boolean, default: false
  end
end
