class AddWidthAndHeightToDojos < ActiveRecord::Migration[5.0]
  def change
    add_column :dojos, :width, :integer, default: 10
    add_column :dojos, :height, :integer, default: 10
  end
end
