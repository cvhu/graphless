class AddAppUser < ActiveRecord::Migration
  def up
  	add_column :apps, :user_id, :integer
  end

  def down
  end
end
