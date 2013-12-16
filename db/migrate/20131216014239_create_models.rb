class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :name
      t.integer :user_id
      t.string :type

      t.timestamps
    end
  end
end
