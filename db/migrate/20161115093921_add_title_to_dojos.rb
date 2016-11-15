class AddTitleToDojos < ActiveRecord::Migration[5.0]
  def change
    add_column :dojos, :title, :string
  end
end
