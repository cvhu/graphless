class ChangeTypeColumn < ActiveRecord::Migration
  def up
  	rename_column :models, :type, :data_type
  end

  def down
  end
end
