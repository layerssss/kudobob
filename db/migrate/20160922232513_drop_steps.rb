class DropSteps < ActiveRecord::Migration[5.0]
  def up
    drop_table :steps
  end
end
