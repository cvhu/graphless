class AddMnodeDataType < ActiveRecord::Migration
  def up
  	add_column :mnodes, :data_type, :string
  end

  def down
  end
end
