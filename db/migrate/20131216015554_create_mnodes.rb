class CreateMnodes < ActiveRecord::Migration
  def change
    create_table :mnodes do |t|
      t.integer :app_id
      t.integer :model_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
