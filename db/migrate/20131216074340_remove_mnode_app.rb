class RemoveMnodeApp < ActiveRecord::Migration
  def up
  	remove_column :mnodes, :app_id
  end

  def down
  end
end
