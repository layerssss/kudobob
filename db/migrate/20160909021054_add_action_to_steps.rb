class AddActionToSteps < ActiveRecord::Migration[5.0]
  def change
    add_column :steps, :action, :string
  end
end
