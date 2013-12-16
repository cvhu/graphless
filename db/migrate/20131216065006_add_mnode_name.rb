class AddMnodeName < ActiveRecord::Migration
  def up
  	add_column :mnodes, :name, :string
  end

  def down
  end
end
